//
//  AutoMoveView.swift
//  Group_8_app
//
//  Created by Kyrollos Ceriacous on 2023-04-21.
//

import SwiftUI

struct AutoMoveButtonView: View {
    // @StateObject private var webSocketHandler = WebSocketHandler()
    @EnvironmentObject var autoMoveState: AutoMoveState

    var body: some View {
        Button(action: {
            autoMoveState.isOn.toggle()
            if autoMoveState.isOn {
                // webSocketHandler.send(message: "A00")
                print("auto move is on, turning off manual controls")
                // send information to the mower that it should stand still a second or two before moving on its own
            } else {
                // webSocketHandler.send(message: "M00")
                print("auto move is off, turning on manual controls")
                // send information to the mower that it should stand still
            }
        }) {
            Text(autoMoveState.isOn ? "AutoMove: On" : "AutoMove: Off")
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding()
                .background(autoMoveState.isOn ? Color.green : Color.gray)
                .cornerRadius(10)
        }
        .frame(width: 250, height: 50)
        .position(x: 210, y: 160)
        .rotationEffect(.degrees(90))
    }
}

struct AutoMoveButtonView_Previews: PreviewProvider {
    static var previews: some View {
        AutoMoveButtonView()
    }
}


