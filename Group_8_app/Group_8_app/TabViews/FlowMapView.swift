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
     var request = URLRequest(url: URL(string: "https://ims8.herokuapp.com/positions/mower")!,timeoutInterval: Double.infinity)
     request.httpMethod = "GET"
     request.addValue(Config.securityKey!, forHTTPHeaderField: "token")

    let session = URLSession.shared
    let task = session.dataTask(with: request) { data, response, error in
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
            if let decodingError = error as? DecodingError {
                switch decodingError {
                case .dataCorrupted(let context):
                    print(context)
                case .keyNotFound(let key, let context):
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                case .valueNotFound(let type, let context):
                    print("Value '\(type)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                case .typeMismatch(let type, let context):
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                @unknown default:
                    fatalError()
                }
            } else {
                print(error)
            }
            completion([])
        }
    }
    
    task.resume()
}

 func GetObstacles(completion: @escaping ([ResponseData]) -> Void) {
     var request = URLRequest(url: URL(string: "https://ims8.herokuapp.com/positions/obstacle")!,timeoutInterval: Double.infinity)
     request.httpMethod = "GET"
     request.addValue(Config.securityKey!, forHTTPHeaderField: "token")
    let session = URLSession.shared
    let task = session.dataTask(with: request) { data, response, error in
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
            if let decodingError = error as? DecodingError {
                switch decodingError {
                case .dataCorrupted(let context):
                    print(context)
                case .keyNotFound(let key, let context):
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                case .valueNotFound(let type, let context):
                    print("Value '\(type)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                case .typeMismatch(let type, let context):
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                @unknown default:
                    fatalError()
                }
            } else {
                print(error)
            }
            completion([])
        }
    }
    
    task.resume()
}
}

func rescalePositions(_ positions: [(x: Double, y: Double)]) -> [(x: Double, y: Double)] {
        let xCoords = positions.map { $0.x }
        let yCoords = positions.map { $0.y }
        
        let minX = xCoords.min() ?? 0.0
        let maxX = xCoords.max() ?? 0.0
        let minY = yCoords.min() ?? 0.0
        let maxY = yCoords.max() ?? 0.0
        
        var rescaledPositions = positions.map { position in
            return (x: (position.x - minX) / (maxX - minX), y: (position.y - minY) / (maxY - minY))
        }
    
    rescaledPositions = rescaledPositions.map { position in
        let xScale: Double = 17 - (-17)
        let xOffset: Double = -17
        let yScale: Double = 28.5 - (-28.5)
        let yOffset: Double = -28.5
        let newX: Double = position.x * xScale + xOffset
        let newY: Double = position.y * yScale + yOffset
        return (x: newX, y: newY)
    }

        
        print(rescaledPositions)
        return rescaledPositions
    }

struct FlowMapView: View {
    
    @State private var mower: [(Double, Double)] = [( 17.0, 28.5)]
    
    @State private var obstacles: [(Double, Double)] = [(-42.0, -42.0)]
    
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
                        let originalX = point.0
                        let originalY = point.1

                        let adjustedX = (originalX * 10) + (geometry.size.width / 2)
                        let adjustedY = (originalY * 10) + (geometry.size.height / 2)
                        
                        path.addRect(CGRect(x: adjustedX - 5, y: adjustedY - 5, width: 10, height: 10))}
                }
                .fill(Color.red)
                // Add points
                ForEach(mower.indices, id: \.self) { index in
                    let color = Color(red: 0, green: 0, blue: 1.0, opacity: 1.0 / Double(index + 1))
                    Path { path in
                        let originalX = mower[index].0
                        let originalY = mower[index].1

                        let adjustedX = (originalX * 10) + (geometry.size.width / 2)
                        let adjustedY = (originalY * 10) + (geometry.size.height / 2)
                        
                        path.addEllipse(in: CGRect(x: adjustedX - 5, y: adjustedY - 5, width: 10, height: 10))
                    }
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
                    mower = rescalePositions(tuples)
                };
                apiManager.GetObstacles { response in
                    // Convert ResponseData structs to (Double, Double) tuples
                    var tuples = response.map { (Double($0.position_horizontal) ?? 0, Double($0.position_vertical) ?? 0) }
                    // Update the @State variable with the tuples
                    tuples = tuples.map { ($0 * 50, $1 * 50) }
                    obstacles = rescalePositions(tuples)
                };
                
                Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { timer in
                    apiManager.GetPositions { response in
                        // Convert ResponseData structs to (Double, Double) tuples
                        var cutResponse = response.suffix(numberOfPoints)
                        var tuples = cutResponse.map { (Double($0.position_horizontal) ?? 0, Double($0.position_vertical) ?? 0) }
                        // Update the @State variable with the tuples
                        tuples = tuples.map { ($0 * 30, $1 * 30) }
                        mower = rescalePositions(tuples)
                    };
                }
                Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { timer in
                    apiManager.GetObstacles { response in
                        // Convert ResponseData structs to (Double, Double) tuples
                        var tuples = response.map { (Double($0.position_horizontal) ?? 0, Double($0.position_vertical) ?? 0) }
                        // Update the @State variable with the tuples
                        tuples = tuples.map { ($0 * 30, $1 * 30) }
                        obstacles = rescalePositions(tuples)
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
