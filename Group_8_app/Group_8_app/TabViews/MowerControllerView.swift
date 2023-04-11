//
//  MowerControllerView.swift
//  Group_8_app
//
//  Created by Kyrollos Ceriacous on 2023-04-05.
//

import SwiftUI

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

struct MowerControllerView: View {
    @State var isRotating = false
    @State var angleValue: CGFloat = 0.0
    
    var body: some View {
        ZStack {
            /*
            Rectangle()
                .fill(Color(hex: 0x273a60))
                .edgesIgnoringSafeArea(.all)
             */
            
            JoyStickBackgroundView()
            JoyStickKnobShadowView()

            Group {
                JoyStickMiddleKnobView()
                KnobTopCircles()
            }
            .offset(x: isRotating ? -30 : 0.0)
            .rotationEffect(.degrees(Double(angleValue)))
            
            IndicatorView(isRotating: $isRotating, angleValue: $angleValue)
            
            Circle()
                .fill(Color.white.opacity(0.001))
                .frame(width: 300, height: 300)
                .gesture(
                    DragGesture(minimumDistance: 0.0)
                        .onChanged({value in self.calculateDegrees(location: value.location)})
                        .onEnded({_ in isRotating = false})
                )
            
            Text("\(String.init(format: "%.0f", angleValue))")
                .font(.title)
                .bold()
                .foregroundColor(.blue)
                .offset(y: 250)
        }
    }
    private func calculateDegrees(location: CGPoint) {
        let vector1 = CGVector(dx: location.x - 150, dy: location.y - 150) // 150 is the radius of the drag circle
        let vector2 = CGVector(dx: 0 - 150, dy: 0 - 150)
        
        let angleV1V2 = atan2(vector2.dy, vector2.dx) - atan2(vector1.dy, vector1.dx)
        
        var degree = angleV1V2 * CGFloat(180.0 / .pi)
        
        if degree < 0 {
            degree += 360.0
        }
        isRotating = true
        angleValue = 360 - degree
        
    }
}

struct IndicatorView: View {
    @Binding var isRotating: Bool
    @Binding var angleValue: CGFloat
    var body: some View {
        ZStack {
            Circle()
                .stroke(style: StrokeStyle(lineWidth: 6, lineCap: .round, dash: [1, 40], dashPhase: 20))
                .frame(width: 250, height: 250)
            
            Circle()
                .trim(from: 0.0, to: 1.0)
                .stroke(
                RadialGradient(
                    gradient: Gradient(colors: [Color.green, Color.green.opacity(0.001)]),
                    center: .top,
                    startRadius: 0,
                    endRadius: 100),
                style: StrokeStyle(lineWidth: 6, lineCap: .round)
                )
                .frame(width: 250, height: 250)
                .opacity(isRotating ? 1.0 : 0.0)
                .rotationEffect(.degrees(-90))
                .rotationEffect(isRotating ? .degrees(angleValue) : .degrees(0))
                .clipShape(
                    Circle()
                        .stroke(style: StrokeStyle(lineWidth: 6,
                                                   lineCap: .round,
                                                   dash: [1, 40],
                                                   dashPhase: 20)
                )
            )
        }
    }
}

struct MowerControllerView_Previews: PreviewProvider {
    static var previews: some View {
        MowerControllerView()
    }
}
