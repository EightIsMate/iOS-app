//
//  LeftRightArrowsView.swift
//  Group_8_app
//
//  Created by Kyrollos Ceriacous on 2023-04-17.
//

import SwiftUI

struct LeftRightArrowsView: View {
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "arrow.left")
                    .resizable()
                    .frame(width: 75, height: 75)
                    .foregroundColor(.white)
                    .background(Color(hex: 0x273a60))
                    .cornerRadius(20)
                    .onTapGesture {
                        print("left arrow pressed")
                    }
                
                Image(systemName: "arrow.right")
                    .resizable()
                    .frame(width: 75, height: 75)
                    .foregroundColor(.white)
                    .background(Color(hex: 0x273a60))
                    .cornerRadius(20)
                    .onTapGesture {
                        print("right arrow pressed")
                    }
            }
        }
        .padding(35)
        .zIndex(1)
    }
}

struct LeftRightArrowsView_Previews: PreviewProvider {
    static var previews: some View {
        LeftRightArrowsView()
    }
}
