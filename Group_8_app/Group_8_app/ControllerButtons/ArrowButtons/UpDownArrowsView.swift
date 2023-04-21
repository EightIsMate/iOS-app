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
    @GestureState private var isPressedUp = false
    @GestureState private var isPressedDown = false

    @State private var upTimer: Timer?
    @State private var downTimer: Timer?

    var body: some View {
        VStack {
            Spacer()

            // Up arrow button
            Button(action: {}) {
                Image(systemName: "arrow.up")
                    .resizable()
                    .frame(width: 75, height: 75)
                    .foregroundColor(.white)
                    .background(isPressedUp ? Color.green : upArrowBackgroundColor)
                    .cornerRadius(20)
            }
            .simultaneousGesture(LongPressGesture(minimumDuration: .infinity).updating($isPressedUp) { (value, state, transaction) in
                state = true
            })
            .onChange(of: isPressedUp) { isPressed in
                if isPressed {
                    upTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                        print("up arrow is being held down")
                    }
                } else {
                    upTimer?.invalidate()
                    upTimer = nil
                }
            }

            // Down arrow button
            Button(action: {}) {
                Image(systemName: "arrow.down")
                    .resizable()
                    .frame(width: 75, height: 75)
                    .foregroundColor(.white)
                    .background(isPressedDown ? Color.green : downArrowBackgroundColor)
                    .cornerRadius(20)
            }
            .simultaneousGesture(LongPressGesture(minimumDuration: .infinity).updating($isPressedDown) { (value, state, transaction) in
                state = true
            })
            .onChange(of: isPressedDown) { isPressed in
                if isPressed {
                    downTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                        print("down arrow is being held down")
                    }
                } else {
                    downTimer?.invalidate()
                    downTimer = nil
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

