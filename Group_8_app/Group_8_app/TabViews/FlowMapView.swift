//
//  FlowMapView.swift
//  Group_8_app
//
//  Created by Kyrollos Ceriacous on 2023-04-05.
//

import SwiftUI

struct ResponseData: Decodable {
    let position_horizontal: String
    let position_vertical: String
    let timestamp: String
    let id: UUID
    let position_type_id: UUID
    let name: String
}


func GetPositions(completion: @escaping ([ResponseData]) -> Void) {
    let url = URL(string: "https://ims8.herokuapp.com/positions/mover")!
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


struct FlowMapView: View {
    
    @State private var mower: [(Double, Double)] = [(-1.0, -1.0)]
    @State private var obstacles: [(Double, Double)] = [(-1.0, -1.0)]
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Path { path in
                    path.move(to: CGPoint(x: 0, y: geometry.size.height / 2))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height / 2))
                }
                .stroke()
                
                // Add Y-axis
                Path { path in
                    path.move(to: CGPoint(x: geometry.size.width / 2, y: 0))
                    path.addLine(to: CGPoint(x: geometry.size.width / 2, y: geometry.size.height))
                }
                .stroke()
                
                Path { path in
                    for (_, point) in obstacles.enumerated() {
                        let point = CGPoint(x: point.0 + 40, y: geometry.size.height - point.1 - 20)
                        path.addRect(CGRect(x: point.x - 5, y: point.y - 5, width: 10, height: 10))}
                }
                .fill(Color.red)
                
                // Add points
                Path { path in
                    for (i, point) in mower.enumerated() {
                        let point = CGPoint(x: point.0 + 40, y: geometry.size.height - point.1 - 20)
                        if i != mower.count - 1 {
                            path.addEllipse(in: CGRect(x: point.x - 5, y: point.y - 5, width: 10, height: 10))}
                    }
                }
                .fill(Color.gray)
                
                Path { path in
                    let pos = mower[mower.count - 1]
                    let point = CGPoint(x: pos.0 + 40, y: geometry.size.height - pos.1 - 20)
                            path.addEllipse(in: CGRect(x: point.x - 5, y: point.y - 5, width: 10, height: 10))
                }
                .fill(Color.blue)
                
             
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .onAppear {
                GetPositions { response in
                    // Convert ResponseData structs to (Double, Double) tuples
                    var tuples = response.map { (Double($0.position_horizontal) ?? 0, Double($0.position_vertical) ?? 0) }
                    // Update the @State variable with the tuples
                    tuples = tuples.map { ($0 * 5, $1 * 5) }
                    mower = tuples
                };
                GetObstacles { response in
                    // Convert ResponseData structs to (Double, Double) tuples
                    var tuples = response.map { (Double($0.position_horizontal) ?? 0, Double($0.position_vertical) ?? 0) }
                    // Update the @State variable with the tuples
                    tuples = tuples.map { ($0 * 5, $1 * 5) }
                    obstacles = tuples
                    print(obstacles)
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
