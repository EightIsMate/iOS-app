//
//  FlowMapView.swift
//  Group_8_app
//
//  Created by Kyrollos Ceriacous on 2023-04-05.
//

import SwiftUI

struct FlowMapView: View {
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 200, height: 200)
                .foregroundColor(.red)
            Text("\("Flow map")")
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .bold))
        }
    }
}

struct FlowMapView_Previews: PreviewProvider {
    static var previews: some View {
        FlowMapView()
    }
}
