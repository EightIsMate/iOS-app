//
//  JoyStickBackground.swift
//  Group_8_app
//
//  Created by Kyrollos Ceriacous on 2023-04-09.
//

import SwiftUI

struct JoyStickBackground: View {
    var body: some View {
        Circle()
            .fill(Color.lightShadow)
            .overlay(
                Circle()
                    .stroke(Color.dipCircle, lineWidth: 50)
            )
            .overlay(
                Circle()
                    .stroke(Color.dipCircle, lineWidth: 35)
                    .blur(radius: 10)
                    .offset(x: 10.0, y: 10.0)
                    .mask(Circle().stroke(lineWidth: 40))
            )
            .overlay(
                Circle()
                    .stroke(Color.darkShadow.opacity(0.8), lineWidth: 35)
                    .blur(radius: 10)
                    .offset(x: -10.0, y: -10.0)
                    .mask(Circle().stroke(lineWidth: 40))
            )
            .overlay(
                Circle()
                    .stroke(Color.lightShadow.opacity(0.9), lineWidth: 35)
                    .blur(radius: 10)
                    .offset(x: 5.0, y: 5.0)
                    .mask(Circle().stroke(lineWidth: 40))
            )
            .overlay(
                Circle()
                    .stroke(Color.lightShadow.opacity(0.8), lineWidth: 35)
                    .blur(radius: 10)
                    .offset(x: -5.0, y: -5.0)
                    .mask(Circle().stroke(lineWidth: 40))
            )
            .overlay(
                Circle()
                    .stroke(Color.lightShadow, lineWidth: 6)
                    .blur(radius: 4)
                    .offset(x: 2.0, y: 2.0)
            )
            .overlay(
                Circle()
                    .stroke(Color.darkShadow, lineWidth: 6)
                    .blur(radius: 4)
                    .offset(x: -2.0, y: -2.0)
            )
            .frame(width: 120, height: 120)
    }
}

struct JoyStickBackground_Previews: PreviewProvider {
    static var previews: some View {
        JoyStickBackground()
    }
}
