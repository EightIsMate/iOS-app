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

func fetchImage(for eventItem: EventItem, completion: @escaping (String?) -> Void) {
    var imageLink: String = ""
    guard let imageID = eventItem.image_id else {
        completion(nil)
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
            completion(imageLink)
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


struct PopupView: View { // The popup window, will add image later
    @Environment(\.presentationMode) var presentationMode
    
    @State var imgLink: String = ""
    let selectedEvent: EventItem
    
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
            }
        }
        .padding()
        Spacer()
            .onAppear(){
                fetchImage(for: selectedEvent){result in
                    if let result = result {
                        self.imgLink = result
                    }
                }
                print(self.imgLink)
            }
        AsyncImage(url: URL(string: imgLink)) {
            phase in
            if let image = phase.image {
                image
                    .resizable()
                    .frame(width: 350, height: 650)
            }
            
        }
        Spacer()
    }
    func dismiss() { // makes the popup button close the popup
        presentationMode.wrappedValue.dismiss()
    }
    
}

struct EventRow: View { // structure of the row
    let event: EventItem
    let infoImage = Image(systemName: "info")
    @State private var isShowingPopup = false

    
    var body: some View {
        HStack { // if event with image, makes it able to press it for a popup
            infoImage
                .foregroundColor(Color(hex: 0x273a60))
                .frame(width: 20, height: 30)
            
            if event.image_id != nil {
                Text(event.message)
                Spacer()
                Button(action: {
                    isShowingPopup = true
                }) {
                
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color(hex: 0x273a60))
                }
                .sheet(isPresented: $isShowingPopup) {
                    PopupView(selectedEvent: event)
                }

            }
            else {
                Text(event.message)
                Spacer()
                if event.image_id != nil {
                    infoImage
                }
            }
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

