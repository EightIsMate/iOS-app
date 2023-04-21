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
    @GestureState private var isPressedLeft = false
    @GestureState private var isPressedRight = false

    @State private var leftTimer: Timer?
    @State private var rightTimer: Timer?
    
    var body: some View {
        HStack {
            // Left arrow button
            Button(action: {}) {
                Image(systemName: "arrow.left")
                    .resizable()
                    .frame(width: 75, height: 75)
                    .foregroundColor(.white)
                    .background(isPressedLeft ? Color.green : leftArrowBackgroundColor)
                    .cornerRadius(20)
            }
            .simultaneousGesture(LongPressGesture(minimumDuration: .infinity).updating($isPressedLeft) { (value, state, transaction) in
                state = true
            })
            .onChange(of: isPressedLeft) { isPressed in
                if isPressed {
                    leftTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                        print("left arrow is being held down")
                    }
                } else {
                    leftTimer?.invalidate()
                    leftTimer = nil
                }
            }

            // Right arrow button
            Button(action: {}) {
                Image(systemName: "arrow.right")
                    .resizable()
                    .frame(width: 75, height: 75)
                    .foregroundColor(.white)
                    .background(isPressedRight ? Color.green : rightArrowBackgroundColor)
                    .cornerRadius(20)
            }
            .simultaneousGesture(LongPressGesture(minimumDuration: .infinity).updating($isPressedRight) { (value, state, transaction) in
                state = true
            })
            .onChange(of: isPressedRight) { isPressed in
                if isPressed {
                    rightTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                        print("right arrow is being held down")
                    }
                } else {
                    rightTimer?.invalidate()
                    rightTimer = nil
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.leading, 35)
        .padding(.top, 35)
    }
}

struct LeftRightArrowsView_Previews: PreviewProvider {
    static var previews: some View {
        LeftRightArrowsView()
    }
}


