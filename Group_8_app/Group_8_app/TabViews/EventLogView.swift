//
//  EventLogView.swift
//  Group_8_app
//
//  Created by Kyrollos Ceriacous on 2023-04-05.
//

import SwiftUI

struct EventItem: Identifiable { // each item in the list
    let id = UUID()
    let title: String
    let type: String
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
                Text(event.title)
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
                Text(event.title)
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
        EventItem(title: "Mower is moving", type: "text"),
        EventItem(title: "Mower has encountered an obstacle", type: "image") // two types of events, one will show
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
        Text("Image Placeholder")
            .foregroundColor(Color(hex: 0x273a60))
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
        Spacer()
        
      /*  ZStack(alignment: .topTrailing) {
            VStack {
                Spacer()
                Text("Image Placeholder")
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                Spacer()
            }
            HStack{
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.black)
                }
            }
            
        } */
        
        
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
