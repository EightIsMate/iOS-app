//
//  AutoMoveView.swift
//  Group_8_app
//
//  Created by Kyrollos Ceriacous on 2023-04-21.
//

import SwiftUI

struct AutoMoveButtonView: View {
    @State var isOn: Bool = false
    
    var body: some View {
        Button(action: {
            self.isOn.toggle()
        }) {
            Text(self.isOn ? "AutoMove: On" : "AutoMove: Off")
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding()
                .background(self.isOn ? Color.green : Color.gray)
                .cornerRadius(10)
        }
        .frame(width: 250, height: 50)
        .position(x: 210, y: 160)
        .rotationEffect(.degrees(90))
    }
}

struct AutoMoveButtonView_Previews: PreviewProvider {
    static var previews: some View {
        AutoMoveButtonView()
    }
}


