//
//  KnobView.swift
//  Group_8_app
//
//  Created by Kyrollos Ceriacous on 2023-04-09.
//

import SwiftUI

struct KnobView: View {
    var body: some View {
        Circle()
            .fill(Color.clear)
            .overlay(
                Circle()
                    .stroke(Color.lightShadow, lineWidth: 4)
                    .blur(radius: 4)
                    .offset(x: 2, y: 2)
                    .mask(Circle())
                
            )
            .overlay(
                Circle()
                    .stroke(Color.darkShadow, lineWidth: 4)
                    .blur(radius: 4)
                    .offset(x: -2, y: -2)
                    .mask(Circle())
                
            )
            .frame(width: 8, height: 8)
    }
}

struct KnobView_Previews: PreviewProvider {
    static var previews: some View {
        KnobView()
    }
}
