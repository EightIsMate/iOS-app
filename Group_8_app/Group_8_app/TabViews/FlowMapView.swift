//
//  FlowMapView.swift
//  Group_8_app
//
//  Created by Kyrollos Ceriacous on 2023-04-05.
//

import SwiftUI
import Foundation

struct ResponseData: Decodable {
    let position_horizontal: String
    let position_vertical: String
    let timestamp: String
    let id: UUID
    let position_type_id: UUID
    let name: String
}

class APIManager {
 func GetPositions(completion: @escaping ([ResponseData]) -> Void) {
    let url = URL(string: "https://ims8.herokuapp.com/positions/mower")!
    let session = URLSession.shared
    let task = session.dataTask(with: url) { data, response, error in
        guard error == nil, let data = data else {
            print("API Error")
            completion([])
            return
        }
    
    let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(Array<ResponseData>.self, from: data)
            completion(response)
        } catch let error {
            print(error)
            completion([])
        }
    }
    
    task.resume()
}

 func GetObstacles(completion: @escaping ([ResponseData]) -> Void) {
    let url = URL(string: "https://ims8.herokuapp.com/positions/obstacle")!
    let session = URLSession.shared
    let task = session.dataTask(with: url) { data, response, error in
        guard error == nil, let data = data else {
            print("API Error")
            completion([])
            return
        }
    
    let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(Array<ResponseData>.self, from: data)
            completion(response)
        } catch let error {
            print(error)
            completion([])
        }
    }
    
    task.resume()
}
}

struct FlowMapView: View {
    
    @State private var mower: [(Double, Double)] = [(-1.0, -1.0)]
    @State private var obstacles: [(Double, Double)] = [(-1.0, -1.0)]
    
    @State var apiManager = APIManager()
    
    let numberOfPoints = 10
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Path { path in
                    path.move(to: CGPoint(x: 10, y: geometry.size.height - 10))
                    path.addLine(to: CGPoint(x: geometry.size.width - 10, y: geometry.size.height - 10))
                }
                .stroke()
                
                Path { path in
                    path.move(to: CGPoint(x: 10, y: 10))
                    path.addLine(to: CGPoint(x: geometry.size.width - 10, y: 10))
                }
                .stroke()
                
                Path { path in
                    path.move(to: CGPoint(x: geometry.size.width - 10, y: 10))
                    path.addLine(to: CGPoint(x: geometry.size.width - 10, y: geometry.size.height - 10))
                }
                .stroke()
                
                Path { path in
                    path.move(to: CGPoint(x: 10, y: 10))
                    path.addLine(to: CGPoint(x: 10, y: geometry.size.height - 10))
                }
                .stroke()
                
                Path { path in
                    for (_, point) in obstacles.enumerated() {
                        let point = CGPoint(x: point.0 + 40, y: geometry.size.height - point.1 - 20)
                        path.addRect(CGRect(x: point.x - 5, y: point.y - 5, width: 20, height: 20))}
                }
                .fill(Color.red)
                // Add points
                ForEach(mower.indices, id: \.self) { index in
                    let color = Color(red: 0, green: 0, blue: 1.0, opacity: 1.0 / Double(index + 1))
                    Path { path in
                        let point = CGPoint(x: mower[index].0 + 40, y: geometry.size.height - CGFloat(mower[index].1) - 20)
                        path.addEllipse(in: CGRect(x: point.x - 5, y: point.y - 5, width: 10, height: 10))}
                    .fill(color)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .onAppear {
            
                apiManager.GetPositions { response in
                    // Convert ResponseData structs to (Double, Double) tuples
                    var cutResponse = response.suffix(numberOfPoints)
                    var tuples = cutResponse.map { (Double($0.position_horizontal) ?? 0, Double($0.position_vertical) ?? 0) }
                    // Update the @State variable with the tuples
                    tuples = tuples.map { ($0 * 50, $1 * 50) }
                    mower = tuples
                };
                apiManager.GetObstacles { response in
                    // Convert ResponseData structs to (Double, Double) tuples
                    var tuples = response.map { (Double($0.position_horizontal) ?? 0, Double($0.position_vertical) ?? 0) }
                    // Update the @State variable with the tuples
                    tuples = tuples.map { ($0 * 50, $1 * 50) }
                    obstacles = tuples
                };
                
                Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { timer in
                    apiManager.GetPositions { response in
                        // Convert ResponseData structs to (Double, Double) tuples
                        var cutResponse = response.suffix(numberOfPoints)
                        var tuples = cutResponse.map { (Double($0.position_horizontal) ?? 0, Double($0.position_vertical) ?? 0) }
                        // Update the @State variable with the tuples
                        tuples = tuples.map { ($0 * 30, $1 * 30) }
                        mower = tuples
                    };
                }
                Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { timer in
                    apiManager.GetObstacles { response in
                        // Convert ResponseData structs to (Double, Double) tuples
                        var tuples = response.map { (Double($0.position_horizontal) ?? 0, Double($0.position_vertical) ?? 0) }
                        // Update the @State variable with the tuples
                        tuples = tuples.map { ($0 * 30, $1 * 30) }
                        obstacles = tuples
                    };
                }
            }
        }.padding(10)
    }
}

struct FlowMapView_Previews: PreviewProvider {
    static var previews: some View {
        FlowMapView()
    }
}
