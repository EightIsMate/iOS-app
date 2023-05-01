import SwiftUI
import Foundation

struct SettingsView: View {
    @StateObject private var webSocketHandler = WebSocketHandler()
    @State private var messageTimer: Timer?
    
    var body: some View {
        VStack {
            Text(webSocketHandler.receivedMessage)
            
            if !webSocketHandler.isConnected {
                Button(action: {
                    webSocketHandler.connect()
                    print("Attempting to connect to rasberry")

                }) {
                    Text("Connect to Raspberry Pi")
                }
                .padding()
            } else {
                Button(action: {
                    /*
                    messageTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
                        webSocketHandler.send(message: "Message from SwiftUI app every 3 seconds")
                    }
                    */
                }) {
                    Text("Start Sending Messages")
                }
                .padding()
                
                Button(action: {
                    messageTimer?.invalidate()
                }) {
                    Text("Stop Sending Messages")
                }
                .padding()
                
                Button(action: {
                    webSocketHandler.disconnect()
                }) {
                    Text("Disconnect")
                }
                .padding()
            }
        }
        /*
         .onAppear {
             webSocketHandler.connect()
         }
         .onDisappear {
             webSocketHandler.disconnect()
         }
         */
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}



