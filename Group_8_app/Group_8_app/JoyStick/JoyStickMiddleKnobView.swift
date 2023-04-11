//
//  JoyStickMiddleKnobView.swift
//  Group_8_app
//
//  Created by Kyrollos Ceriacous on 2023-04-09.
//

import SwiftUI

struct JoyStickMiddleKnobView: View {
    var body: some View {
        Circle()
            .fill(Color.viewBackground)
            .overlay(
                Circle()
                    .stroke(Color.white.opacity(0.5), lineWidth: 3)
                    .blur(radius: 4)
                    .offset(x: 2, y: 2)
                    .mask(Circle())
                
            )
            .overlay(
                Circle()
                    .stroke(Color.black.opacity(0.8), lineWidth: 6)
                    .blur(radius: 4)
                    .offset(x: -2, y: -2)
                    .mask(Circle())
                
            )
            .frame(width: 90, height: 90)
    }
}

struct JoyStickMiddleKnobView_Previews: PreviewProvider {
    static var previews: some View {
        JoyStickMiddleKnobView()
    }
}
