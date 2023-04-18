//
//  EventLogView.swift
//  Group_8_app
//
//  Created by Kyrollos Ceriacous on 2023-04-05.
//

import SwiftUI

let testResponse = [{
    let id : UUID = UUID()
    let event_message: String = "Mower is moving"
    let url: String = "";
}, {
    let id : UUID = UUID()
    let event_message: String = "Mower has encountered an obstacle"
    let url: String = "https://res.cloudinary.com/dqv4uub04/image/upload/v1681737973/huwswzzoyxv1rqp0porb.jpg";
}, {
    let id : UUID = UUID()
    let event_message: String = "Mower has stopped"
    let url: String = "";
}]


struct EventItem: Identifiable { // each item in the list
    let id = UUID()
    let event_message: String
    let type: String
}


/* func APIEventCall(completion: @escaping (String?) -> Void) {
    let url = URL(string: "https://ims8.herokuapp.com/positions")!
    let session = URLSession.shared
    let task = session.dataTask(with: url) { data, response, error in
        guard error == nil, let data = data else {
            print("API Error")
            completion("API Error")
            return
        }
    
    let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(Array<ResponseData>.self, from: data)
            
            completion(response[2].position_horizontal + " : " + response[2].position_vertical)
        } catch let error {
            print(error)
            completion("Error: \(error)")
        }
    }
    
    task.resume()
}
*/



struct EventRow: View { // structure of the row
    let event: EventItem
    let infoImage = Image(systemName: "info")
    @State private var isShowingPopup = false

    
    var body: some View {
        HStack { // if event with image, makes it able to press it for a popup
            infoImage
                .foregroundColor(Color(hex: 0x273a60))
                .frame(width: 20, height: 30)
            
            if event.type == "image" {
                Text(event.event_message)
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
                Text(event.event_message)
                Spacer()
                if event.type == "image" {
                    infoImage
                }
            }
            
            
            
        }
    }
}

struct EventLogView: View {
    let events = [
        EventItem(event_message: "Mower is moving", type: "text"),
        EventItem(event_message: "Mower has encountered an obstacle", type: "image") // two types of events, one will show
    ] // Which type of event, API call
    
    let infoImage = Image(systemName: "info")
    
    var body: some View {
        List {
            ForEach(events) { event in // lists all events
                EventRow(event: event)
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
        EventLogView()
    }
}
