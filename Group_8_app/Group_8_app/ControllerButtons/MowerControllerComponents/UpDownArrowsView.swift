//
//  UpDownArrowsView.swift
//  Group_8_app
//
//  Created by Kyrollos Ceriacous on 2023-04-17.
//

import SwiftUI

struct UpDownArrowsView: View {
    @State var upArrowBackgroundColor = Color(hex: 0x273a60)
    @State var downArrowBackgroundColor = Color(hex: 0x273a60)

    @State private var upTimer: Timer?
    @State private var downTimer: Timer?
    @State private var idleTimer: Timer?
    
    @GestureState private var isPressedUp = false
    @GestureState private var isPressedDown = false
    
    @EnvironmentObject var webSocketHandler: WebSocketHandler
    @EnvironmentObject var idleState: IdleState
    @EnvironmentObject var autoMoveState: AutoMoveState
    var body: some View {
        VStack {
            Spacer()

            // Up arrow button
            Button(action: {}) {
                Image(systemName: "arrow.up")
                    .resizable()
                    .frame(width: 75, height: 75)
                    .foregroundColor(.white)
                    .background(isPressedUp ? Color.green : (autoMoveState.isOn ? Color.gray : upArrowBackgroundColor))
                    .cornerRadius(20)
            }
            .disabled(autoMoveState.isOn)
            .simultaneousGesture(autoMoveState.isOn ? nil : LongPressGesture(minimumDuration: .infinity)
                .updating($isPressedUp) { (value, state, transaction) in
                state = true
            })
            .onChange(of: isPressedUp) { isPressed in
                if isPressed {
                    idleState.stopIdleTimer()
                    upTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                        webSocketHandler.send(message: "M03\n")
                    }
                } else {
                    upTimer?.invalidate()
                    upTimer = nil
                    idleState.startIdleTimer()
                    webSocketHandler.send(message: "M00\n")
                }
            }

            // Down arrow button
            Button(action: {}) {
                Image(systemName: "arrow.down")
                    .resizable()
                    .frame(width: 75, height: 75)
                    .foregroundColor(.white)
                    .background(isPressedDown ? Color.green : (autoMoveState.isOn ? Color.gray : downArrowBackgroundColor))
                    .cornerRadius(20)
            }
            .disabled(autoMoveState.isOn)
            .simultaneousGesture(autoMoveState.isOn ? nil : LongPressGesture(minimumDuration: .infinity)
                .updating($isPressedDown) { (value, state, transaction) in
                state = true
            })
            .onChange(of: isPressedDown) { isPressed in
                if isPressed {
                    idleState.stopIdleTimer()
                    downTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                        webSocketHandler.send(message: "M04\n")
                    }
                } else {
                    downTimer?.invalidate()
                    downTimer = nil
                    idleState.startIdleTimer()
                    webSocketHandler.send(message: "M00\n")
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
        .padding(.leading, 35)
        .padding(.bottom, 80)
    }
}

struct UpDownArrowsView_Previews: PreviewProvider {
    static var previews: some View {
        UpDownArrowsView()
    }
}


