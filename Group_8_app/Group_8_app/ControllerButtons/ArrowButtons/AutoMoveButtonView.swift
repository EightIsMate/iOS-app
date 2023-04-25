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
            print(autoMoveState.isOn)
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


