//
//  MowerControllerView.swift
//  Group_8_app
//
//  Created by Kyrollos Ceriacous on 2023-04-05.
//

import SwiftUI

/*
extension Color {
    static let viewBackground = Color.init(red: 40/255, green: 64/255, blue: 105/255)
    static let lightShadow = Color.init(red: 23/255, green: 44/255, blue: 81/255)
    static let darkShadow = Color.init(red: 13/255, green: 16/255, blue: 24/255)
    
    static let dipCircle = LinearGradient(
        gradient: Gradient (
            colors: [lightShadow.opacity(0.3), darkShadow.opacity(0.3)]
        ),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let dipCircle1 = LinearGradient (
        gradient: Gradient (
            colors: [Color.darkShadow]
        ),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
*/

struct MowerControllerView: View {
    var body: some View {
        ControllerButtonsView()
    }
}


struct MowerControllerView_Previews: PreviewProvider {
    static var previews: some View {
        MowerControllerView()
    }
}
