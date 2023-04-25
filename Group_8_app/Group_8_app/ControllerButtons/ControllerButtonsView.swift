//
//  ControllerButtonsView.swift
//  Group_8_app
//
//  Created by Kyrollos Ceriacous on 2023-04-17.
//

import SwiftUI

struct ControllerButtonsView: View {
    @EnvironmentObject var webSocketHandler: WebSocketHandler
    
    @StateObject private var idleState = IdleState()
    @StateObject private var autoMoveState = AutoMoveState()

    var body: some View {
        ZStack(alignment: .topLeading) {
            LeftRightArrowsView()
                .environmentObject(webSocketHandler)
                .environmentObject(idleState)
                .environmentObject(autoMoveState)
            UpDownArrowsView()
                .environmentObject(webSocketHandler)
                .environmentObject(idleState)
                .environmentObject(autoMoveState)
            AutoMoveButtonView()
                .environmentObject(webSocketHandler)
                .environmentObject(idleState)
                .environmentObject(autoMoveState)
        }
    }
}


struct ControllerButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        ControllerButtonsView()
        
    }
}
