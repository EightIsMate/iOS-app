//
//  JoyStickKnobShadowView.swift
//  Group_8_app
//
//  Created by Kyrollos Ceriacous on 2023-04-09.
//

import SwiftUI

struct JoyStickKnobShadowView: View {
    var body: some View {
        Circle()
            .fill(Color.lightShadow)
            .overlay(
                Circle()
                    .stroke(Color.dipCircle1, lineWidth: 30)
                    .blur(radius: 5)
            )
            .frame(width: 60, height: 60)
    }
}

struct JoyStickKnobShadowView_Previews: PreviewProvider {
    static var previews: some View {
        JoyStickKnobShadowView()
    }
}
