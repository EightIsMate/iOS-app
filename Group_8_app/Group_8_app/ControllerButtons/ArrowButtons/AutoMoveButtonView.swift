//
//  AutoMoveView.swift
//  Group_8_app
//
//  Created by Kyrollos Ceriacous on 2023-04-21.
//

import SwiftUI

struct AutoMoveButtonView: View {
    @EnvironmentObject var autoMoveState: AutoMoveState
    @EnvironmentObject var webSocketHandler: WebSocketHandler


    var body: some View {
        Button(action: {
            autoMoveState.isOn.toggle()
            if autoMoveState.isOn == true {
                print("initing auto move")
                webSocketHandler.send(message: "A00\n")
            } else {
                print("initing manual control")
                webSocketHandler.send(message: "M00\n")
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
        .onAppear {
            if autoMoveState.isOn {
                autoMoveState.isOn = true
            } else {
                autoMoveState.isOn = false
            }
        }
    }
}

struct AutoMoveButtonView_Previews: PreviewProvider {
    static var previews: some View {
        AutoMoveButtonView()
    }
}


