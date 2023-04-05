//
//  MowerControllerView.swift
//  Group_8_app
//
//  Created by Kyrollos Ceriacous on 2023-04-05.
//

import SwiftUI

struct MowerControllerView: View {
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 200, height: 200)
                .foregroundColor(.blue)
            Text("\("Mower controller")")
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .bold))
        }
    }
}

struct MowerControllerView_Previews: PreviewProvider {
    static var previews: some View {
        MowerControllerView()
    }
}
