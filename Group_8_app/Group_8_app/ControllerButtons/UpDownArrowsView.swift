//
//  UpDownArrowsView.swift
//  Group_8_app
//
//  Created by Kyrollos Ceriacous on 2023-04-17.
//

import SwiftUI

struct UpDownArrowsView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Image(systemName: "arrow.up")
                .resizable()
                .frame(width: 75, height: 75)
                .foregroundColor(.blue)
                .background(Color.red)
                .onTapGesture {
                    print("arrow up pressed")
                }
                .padding(30)
            
            Image(systemName: "arrow.down")
                .resizable()
                .frame(width: 75, height: 75)
                .foregroundColor(.blue)
                .background(Color.green)
                .onTapGesture {
                    print("arrow down pressed")
                }
        }
        .frame(maxWidth: .infinity, alignment: .bottomLeading)
        .padding(.leading, 35)
        .padding(.bottom, 35)
    }
}

struct UpDownArrowsView_Previews: PreviewProvider {
    static var previews: some View {
        UpDownArrowsView()
    }
}
