//
//  EventLogView.swift
//  Group_8_app
//
//  Created by Kyrollos Ceriacous on 2023-04-05.
//

import SwiftUI

/*let testResponse: [EventItem] = [
    EventItem(event_message: "Mower is moving", type: "text"),
    EventItem(event_message: "Mower has encountered an obstacle", type: "image", imageURL: URL(string: "https://res.cloudinary.com/dqv4uub04/image/upload/v1681737973/huwswzzoyxv1rqp0porb.jpg")),
    EventItem(event_message: "Mower has stopped", type: "text")
]*/

/*struct EventItem: Decoder, Identifiable {
    let image_id: UUID?  //error if it's going to decode a nil value to a non-optional type.
    let timestamp: String
    let message: String // new property to store the image URL
    
    init(event_message: String, type: String, imageID: UUID? = nil) {
        self.message = event_message
        self.image_id = imageID
    }
}
*/
struct mEventItem: Decodable, Identifiable{
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


func fetchData(completion: @escaping (mEventItem?) -> Void) {
    var results: String?
    var logItems = [mEventItem]()

    var request = URLRequest(url: URL(string: "https://ims8.herokuapp.com/events")!,timeoutInterval: Double.infinity)
    request.httpMethod = "GET"

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else {
            print(String(describing: error))
            completion(nil)
            return
        }
        do {
            let decodedData = try JSONDecoder().decode([mEventItem].self, from: data)
            logItems = decodedData
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

        completion(logItems[0])
    }
    task.resume()
    return
}


struct EventRow: View { // structure of the row
    let event: mEventItem
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
                    PopupView()
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
    @State var results: String = ""
    
    @State var events: [mEventItem]  // initialize events as empty array

    
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
                    /*
                 //   let mes = result
                 //   let endOfSentence = mes.firstIndex(of: ",")!
                 //   let trimmedMessage = mes[...endOfSentence]
                    
                    var newEventType = "image" // default event type
                    if mes.contains("text") {
                        newEventType = "text" // if message contains "text", set event type to "text"
                    }
                    */
                    let newEvent = result // mEventItem(message: String(trimmedMessage))
                    self.events.append(newEvent) // Append new EventItem to the existing events array
                }
            }
        }
    }
}


struct PopupView: View { // The popup window, will add image later
    @Environment(\.presentationMode) var presentationMode
    
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
        AsyncImage(url: URL(string: "https://res.cloudinary.com/dqv4uub04/image/upload/v1681737973/huwswzzoyxv1rqp0porb.jpg")!) {
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



struct EventLogView_Previews: PreviewProvider {
    static var previews: some View {
        EventLogView( events: <#[mEventItem]#>)
    }
}
