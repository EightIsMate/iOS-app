//
//  EventLogView.swift
//  Group_8_app
//
//  Created by Kyrollos Ceriacous on 2023-04-05.
//

import SwiftUI

struct EventItem: Decodable, Identifiable{
    let id: UUID
    let image_id: UUID?  //error if it's going to decode a nil value to a non-optional type.
    let timestamp: String
    let message: String
    
    init(id: UUID, image_id: UUID? = nil, timestamp: String, message: String) {
        self.message = message
        self.image_id = image_id
        self.id = id
        self.timestamp = timestamp
    }
}

struct imageItems: Decodable, Identifiable{
    let id: UUID
    let img_link: String?  //error if it's going to decode a nil value to a non-optional type.
    let position_id: String
    let labels: [String]?
}

func fetchData(completion: @escaping (EventItem?) -> Void) {
    var logItems = [EventItem]()
    var request = URLRequest(url: URL(string: "https://ims8.herokuapp.com/events")!,timeoutInterval: Double.infinity)
    request.httpMethod = "GET"
    request.addValue(Config.securityKey!, forHTTPHeaderField: "token")

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else {
            print(String(describing: error))
            completion(nil)
            return
        }
        do {
            let decodedData = try JSONDecoder().decode([EventItem].self, from: data)
            logItems = decodedData
            for item in logItems {
                completion(item)
            }
        }
        catch DecodingError.keyNotFound(let key, let context) {
            Swift.print("could not find key \(key) in JSON: \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            Swift.print("could not find type \(type) in JSON: \(context.debugDescription)")
        } catch DecodingError.typeMismatch(let type, let context) {
            Swift.print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(let context) {
            Swift.print("data found to be corrupted in JSON: \(context.debugDescription)")
        } catch let error as NSError {
            NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
        }
    }
    task.resume()
    return
}

func fetchImage(for eventItem: EventItem, completion: @escaping ((String?, [String])) -> Void) {
    var imageLink: String = ""
    guard let imageID = eventItem.image_id else {
        completion((nil, []))
        return
    }
    var request = URLRequest(url: URL(string: "https://ims8.herokuapp.com/image/\(imageID)")!,timeoutInterval: Double.infinity)
    request.httpMethod = "GET"
    request.addValue(Config.securityKey!, forHTTPHeaderField: "token")
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else {
            print(String(describing: error))
            return
        }
        do {
            let decodedData = try JSONDecoder().decode(imageItems.self, from: data)
            imageLink = decodedData.img_link ?? ""
            var imageLabels = [String]()
            if let labels = decodedData.labels, labels.count >= 3 {
                imageLabels = Array(labels.prefix(3))
            }
            completion((imageLink, imageLabels))
        }
        catch DecodingError.keyNotFound(let key, let context) {
            Swift.print("could not find key \(key) in JSON: \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            Swift.print("could not find type \(type) in JSON: \(context.debugDescription)")
        } catch DecodingError.typeMismatch(let type, let context) {
            Swift.print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(let context) {
            Swift.print("data found to be corrupted in JSON: \(context.debugDescription)")
        } catch let error as NSError {
            NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
        }
        
    }
    task.resume()
    return
}

struct PopupView: View {
    let selectedEvent: EventItem

    @Environment(\.presentationMode) var presentationMode
    
    @State var imgLink: String = ""
    @State var imgLabels: [String] = []
    
    @State private var isTextboxVisible = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color(hex: 0x273a60))
                }
            }.padding()

            ZStack {
                AsyncImage(url: URL(string: imgLink)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .frame(width: 350, height: 650)
                    } else if phase.error != nil {
                        Image(systemName: "exclamationmark.icloud")
                            .resizable()
                            .frame(width: 350, height: 650)
                    } else {
                        Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                            .resizable()
                            .frame(width: 350, height: 650)
                    }
                }
                .aspectRatio(contentMode: .fit)
            }

            if isTextboxVisible {
                ScrollView(.horizontal, showsIndicators: false) {
                    Text(imgLabels.joined(separator: ", "))
                        .padding()
                        .background(Color.white)
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                        .frame(height: 50)
                }
                .padding(.top, 10)
            }
        }
        .onAppear(){
            fetchImage(for: selectedEvent){imageLink, imageLabels in
                if let imageLink = imageLink {
                    self.imgLink = imageLink
                    self.isTextboxVisible = true
                }
                self.imgLabels = imageLabels
            }
            print(self.imgLink)
        }
    }
    
    func dismiss() { // makes the popup button close the popup
        presentationMode.wrappedValue.dismiss()
    }
}


struct EventRow: View {
    let event: EventItem
    let infoImage = Image(systemName: "info")
    @State private var isShowingPopup = false

    var body: some View {
        HStack {
            infoImage
                .foregroundColor(Color(hex: 0x273a60))
                .frame(width: 20, height: 30)
            
            Text(event.message)
            Spacer()
            
            if event.image_id != nil {
                Image(systemName: "chevron.right")
                    .foregroundColor(Color(hex: 0x273a60))
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if event.image_id != nil {
                isShowingPopup = true
            }
        }
        .sheet(isPresented: $isShowingPopup) {
            PopupView(selectedEvent: event)
        }
    }
}


struct EventLogView: View {
    
    @State var events: [EventItem] = [] // initialize events as empty array

    let infoImage = Image(systemName: "info")
    
    var body: some View {
        List {
            ForEach(events) { event in // lists all events
                EventRow(event: event)
            }
        }
        .onAppear(){
            fetchData { result in
                if let result = result {
                    let newEvent = result // EventItem(message: String(trimmedMessage))
                    self.events.append(newEvent) // Append new EventItem to the existing events array
                }
            }
        }
        .onDisappear(){
            events.removeAll()
        }
    }
}

struct EventLogView_Previews: PreviewProvider {
    static var previews: some View {
        EventLogView()
    }
}

