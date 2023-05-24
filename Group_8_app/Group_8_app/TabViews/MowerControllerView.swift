//
//  MowerControllerView.swift
//  Group_8_app
//
//  Created by Kyrollos Ceriacous on 2023-04-05.
//

import SwiftUI

struct MowerControllerView: View {
    @EnvironmentObject var webSocketHandler: WebSocketHandler
    
    @StateObject private var idleState = IdleState()
    @StateObject private var autoMoveState = AutoMoveState()
    var body: some View {
        ControllerButtonsView()
            .environmentObject(webSocketHandler)
            .environmentObject(idleState)
            .environmentObject(autoMoveState)
            .onAppear {
                webSocketHandler.connect()
                if autoMoveState.isOn {
                    webSocketHandler.send(message: "A00\n")
                } else {
                    webSocketHandler.send(message: "M00\n")
                }
            }
            .onDisappear {
                if autoMoveState.isOn {
                    webSocketHandler.send(message: "A00\n")
                } else {
                    webSocketHandler.send(message: "I00\n")
                }
                webSocketHandler.disconnect()
            }
    }
}


struct MowerControllerView_Previews: PreviewProvider {
    static var previews: some View {
        MowerControllerView()
    }
}
