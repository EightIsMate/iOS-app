//
//  EventLogView.swift
//  Group_8_app
//
//  Created by Kyrollos Ceriacous on 2023-04-05.
//

import SwiftUI

struct EventItem: Identifiable {
    let id = UUID()
    let title: String
    let type: String
}

struct EventRow: View {
    let event: EventItem
    let infoImage = Image(systemName: "info")

    
    var body: some View {
        HStack {
            infoImage
                .foregroundColor(.black)
                .frame(width: 20, height: 30)
            
            Text(event.title)
            Spacer()
            if event.type == "image" {
                infoImage
            }
        }
    }
}

struct EventLogView: View {
    let events = [
        EventItem(title: "Mower is moving", type: "text"),
        EventItem(title: "Mower has encountered an obstacle", type: "image")
    ] // Which type of event, API call
    
    let infoImage = Image(systemName: "info")
    
    var body: some View {
        List {
            ForEach(events) { event in
                EventRow(event: event)
            }
        }
    }
    
  
}

struct EventLogView_Previews: PreviewProvider {
    static var previews: some View {
        EventLogView()
    }
}
