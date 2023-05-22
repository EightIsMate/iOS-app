//
//  ContentView.swift
//  Group_8_app
//
//  Created by Kyrollos Ceriacous on 2023-04-05.
//

import SwiftUI

/* Extension to the Color class that lets us use colors in a hexdecimal format */
extension Color {
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double((hex & 0xff) >> 0) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}

struct ContentView: View {
    @State var selectedTab = "Mower Controller"

    var body: some View {
        NavigationView() {
            TabView(selection: $selectedTab) {
                MowerControllerView()
                    .onTapGesture {
                        selectedTab = "Mower Controller"
                    }
                    .tabItem {
                        Image(systemName: "gamecontroller")
                        Text("Mower Controller")
                    }
                    .tag("Mower Controller")
                FlowMapView()
                    .onTapGesture {
                        selectedTab = "Flow map"
                    }
                    .tabItem {
                        Image(systemName: "map")
                        Text("Flow map")
                    }
                    .tag("Flow map")
                EventLogView()
                    .onTapGesture {
                        selectedTab = "Event Log"
                    }
                    .tabItem {
                        Image(systemName: "book")
                        Text("Event log")
                    }
                    .tag("Event Log")
                /*
                SettingsView()
                    .onTapGesture {
                        selectedTab = "Settings"
                    }
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                    .tag("Settings")
                */
            }
            .accentColor(Color(hex: 0x273a60))
            .navigationTitle("\(selectedTab)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
