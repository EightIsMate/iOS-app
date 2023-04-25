//
//  LeftRightArrowsView.swift
//  Group_8_app
//
//  Created by Kyrollos Ceriacous on 2023-04-17.
//

import SwiftUI

struct LeftRightArrowsView: View {
    @State var leftArrowBackgroundColor = Color(hex: 0x273a60)
    @State var rightArrowBackgroundColor = Color(hex: 0x273a60)
    
    @State private var leftTimer: Timer?
    @State private var rightTimer: Timer?
    @State private var idleTimer: Timer?
    
    @GestureState private var isPressedLeft = false
    @GestureState private var isPressedRight = false
    
    // @StateObject private var webSocketHandler = WebSocketHandler()
    @EnvironmentObject var webSocketHandler: WebSocketHandler
    @EnvironmentObject var idleState: IdleState
    @EnvironmentObject var autoMoveState: AutoMoveState

    var body: some View {
        HStack {
            // Left arrow button
            Button(action: {}) {
                Image(systemName: "arrow.left")
                    .resizable()
                    .frame(width: 75, height: 75)
                    .foregroundColor(.white)
                    .background(isPressedLeft ? Color.green : (autoMoveState.isOn ? Color.gray : leftArrowBackgroundColor))
                    .cornerRadius(20)
            }
            .disabled(autoMoveState.isOn)
            .simultaneousGesture(LongPressGesture(minimumDuration: .infinity).updating($isPressedLeft) { (value, state, transaction) in
                state = true
            })
            .onChange(of: isPressedLeft) { isPressed in
                if isPressed {
                    idleState.stopIdleTimer()
                    leftTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                        print("2")
                        webSocketHandler.send(message: "M20")
                    }
                } else {
                    leftTimer?.invalidate()
                    leftTimer = nil
                    idleState.startIdleTimer()
                    // send information to the mower that it should stand still
                    // as long as no buttons a pressed the mower should stand completely still
                }
            }

            // Right arrow button
            Button(action: {}) {
                Image(systemName: "arrow.right")
                    .resizable()
                    .frame(width: 75, height: 75)
                    .foregroundColor(.white)
                    .background(isPressedRight ? Color.green : (autoMoveState.isOn ? Color.gray : rightArrowBackgroundColor))
                    .cornerRadius(20)
            }
            .disabled(autoMoveState.isOn)
            .simultaneousGesture(LongPressGesture(minimumDuration: .infinity).updating($isPressedRight) { (value, state, transaction) in
                state = true
            })
            .onChange(of: isPressedRight) { isPressed in
                if isPressed {
                    idleState.stopIdleTimer()
                    rightTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                        print("1")
                        webSocketHandler.send(message: "M10")
                    }
                } else {
                    rightTimer?.invalidate()
                    rightTimer = nil
                    idleState.startIdleTimer()
                    // send information to the mower that it should stand still
                    // as long as no buttons a pressed the mower should stand completely still
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.leading, 35)
        .padding(.top, 35)
        .onAppear {
            webSocketHandler.connect()
        }
        .onDisappear {
            webSocketHandler.disconnect()
        }
    }
}

struct LeftRightArrowsView_Previews: PreviewProvider {
    static var previews: some View {
        LeftRightArrowsView()
    }
}


