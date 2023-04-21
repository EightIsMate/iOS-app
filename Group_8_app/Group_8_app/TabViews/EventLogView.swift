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

/*func fetchData() -> String {
    
    var results: String
    
    var request = URLRequest(url: URL(string: "https://ims8.herokuapp.com/events")!,timeoutInterval: Double.infinity)
    request.httpMethod = "GET"

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else {
            print(String(describing: error))
            return
        }
        results = String(data: data, encoding: .utf8)!
        print(String(data: data, encoding: .utf8)!)

    }

    task.resume()
    return results

}*/

struct MyJson: Codable {
    let message: String
}

func fetchData(completion: @escaping (String?) -> Void) {
    var results: String?

    var request = URLRequest(url: URL(string: "https://ims8.herokuapp.com/events")!,timeoutInterval: Double.infinity)
    request.httpMethod = "GET"

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else {
            print(String(describing: error))
            completion(nil)
            return
        }
        results = String(data: data, encoding: .utf8)

        let jsonData = results?.data(using: .utf8)!
        let decoder = JSONDecoder()

        do {
            let myJson = try decoder.decode(MyJson.self, from: jsonData!)

            print(myJson) // Output: "John Doe"
        } catch {
            print(error)
        }
        //print(results![3] )

        completion(results)
    }

    task.resume()
    return 
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
    @State var results: String = ""
    /* var events = [
        EventItem(event_message: results , type: "text"),
        EventItem(event_message: "Mower has encountered an obstacle", type: "image") // two types of events, one will show
    ] */ // Which type of event, API call
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
                if var result = result {
                    self.results = result
                    self.events = [EventItem(event_message: self.results, type: "text"), // initialize events here
                                                       EventItem(event_message: "Mower has encountered an obstacle", type: "image")]
                    print("test")
                    print(results)
                
                } else {
                    // handle the error case
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
        EventLogView()
    }
}
