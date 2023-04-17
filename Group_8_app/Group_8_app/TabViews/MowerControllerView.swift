//
//  MowerControllerView.swift
//  Group_8_app
//
//  Created by Kyrollos Ceriacous on 2023-04-05.
//

import SwiftUI

extension Color {
    // hello
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

struct MowerControllerView: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack {
                HStack {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .frame(width: 75, height: 75)
                        .foregroundColor(.blue)
                        .background(Color.yellow)
                        .onTapGesture {
                            print("left arrow pressed")
                        }
                    
                    Image(systemName: "arrow.right")
                        .resizable()
                        .frame(width: 75, height: 75)
                        .foregroundColor(.blue)
                        .background(Color.pink)
                        .onTapGesture {
                            print("right arrow pressed")
                        }
                }
            }
            .padding(35)
            .zIndex(1)
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
}


struct MowerControllerView_Previews: PreviewProvider {
    static var previews: some View {
        MowerControllerView()
    }
}
