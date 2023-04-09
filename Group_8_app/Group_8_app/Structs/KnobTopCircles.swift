//
//  KnobTopCircles.swift
//  Group_8_app
//
//  Created by Kyrollos Ceriacous on 2023-04-09.
//

import SwiftUI

struct KnobTopCircles: View {
    var body: some View {
        ZStack {
            KnobView()
                .offset(x: 30)
            KnobView()
                .offset(x: -30)
            KnobView()
                .offset(y: 30)
            KnobView()
                .offset(y: -30)
        }
    }
}

struct KnobTopCircles_Previews: PreviewProvider {
    static var previews: some View {
        KnobTopCircles()
    }
}
