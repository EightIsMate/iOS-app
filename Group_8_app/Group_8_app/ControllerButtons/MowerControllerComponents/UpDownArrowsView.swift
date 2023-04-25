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
            .simultaneousGesture(LongPressGesture(minimumDuration: .infinity).updating($isPressedUp) { (value, state, transaction) in
                state = true
            })
            .onChange(of: isPressedUp) { isPressed in
                if isPressed {
                    idleState.stopIdleTimer()
                    upTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                        print("3")
                    }
                } else {
                    upTimer?.invalidate()
                    upTimer = nil
                    idleState.startIdleTimer()
                    // send information to the mower that it should stand still
                    // as long as no buttons a pressed the mower should stand completely still
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
            .simultaneousGesture(LongPressGesture(minimumDuration: .infinity).updating($isPressedDown) { (value, state, transaction) in
                state = true
            })
            .onChange(of: isPressedDown) { isPressed in
                if isPressed {
                    idleState.stopIdleTimer()
                    downTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                        print("4")
                    }
                } else {
                    downTimer?.invalidate()
                    downTimer = nil
                    idleState.startIdleTimer()
                    // send information to the mower that it should stand still
                    // as long as no buttons a pressed the mower should stand completely still
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
        .padding(.leading, 35)
        .padding(.bottom, 35)
    }
}

struct UpDownArrowsView_Previews: PreviewProvider {
    static var previews: some View {
        UpDownArrowsView()
    }
}


