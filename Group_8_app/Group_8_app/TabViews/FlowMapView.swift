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

func rescalePositions(_ positions: [(x: Double, y: Double)],_ obstacles: [(x: Double, y: Double)]) -> (mower: [(x: Double, y: Double)], obstacles: [(x: Double, y: Double)]) {
    let allInfo = positions + obstacles
    let xCoords = allInfo.map { $0.x }
    let yCoords = allInfo.map { $0.y }
    
    let minX = xCoords.min() ?? 0.0
    let maxX = xCoords.max() ?? 0.0
    let minY = yCoords.min() ?? 0.0
    let maxY = yCoords.max() ?? 0.0
    
    var rescaledPositions = positions.map { position in
        return (x: (position.x - minX) / (maxX - minX), y: (position.y - minY) / (maxY - minY))
    }
    
    var rescaledObstacles = obstacles.map { position in
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
    
    rescaledObstacles = rescaledObstacles.map { position in
        let xScale: Double = 17 - (-17)
        let xOffset: Double = -17
        let yScale: Double = 28.5 - (-28.5)
        let yOffset: Double = -28.5
        let newX: Double = position.x * xScale + xOffset
        let newY: Double = position.y * yScale + yOffset
        return (x: newX, y: newY)
    }
    return (rescaledPositions, rescaledObstacles)
    }

struct ResponseData: Decodable {
    let value: String
}

func APICall(completion: @escaping (String?) -> Void) {
    let url = URL(string: "https://api.chucknorris.io/jokes/random")!
    let session = URLSession.shared
    let task = session.dataTask(with: url) { data, response, error in
        guard error == nil, let data = data else {
            print("API Error")
            completion("API Error")
            return
        }
    
    let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(ResponseData.self, from: data)
            completion(response.value)
        } catch {
            print("Decode Error")
            completion("Decode Error")
        }
    }
    
    task.resume()
}

struct FlowMapView: View {    
    @State private var mower: [(Double, Double)] = [(-42.0, -42.0)]
    @State private var obstacles: [(Double, Double)] = [(-42.0, -42.0)]
    @State var apiManager = APIManager()
    
    let numberOfPoints = 100
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
                        
                        // Obstacles size
                        path.addRect(CGRect(x: adjustedX - 5, y: adjustedY - 5, width: 15, height: 15))}
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
                        
                        path.addEllipse(in: CGRect(x: adjustedX - 6, y: adjustedY - 6, width: 12, height: 12))
                    }
                    .fill(color)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { timer in
                    apiManager.GetPositions { response in
                        // Convert ResponseData structs to (Double, Double) tuples
                        let cutResponse = response.prefix(numberOfPoints)
                        var tuplesPos = cutResponse.map { (Double($0.position_horizontal) ?? 0, Double($0.position_vertical) ?? 0) }
                        // Update the tuples
                        tuplesPos = tuplesPos.map { ($0 * 30, $1 * 30) }
                    
                        apiManager.GetObstacles { response in
                            // Convert ResponseData structs to (Double, Double) tuples
                            var tuplesObs = response.map { (Double($0.position_horizontal) ?? 0, Double($0.position_vertical) ?? 0) }
                            // Update the tuples
                            tuplesObs = tuplesObs.map { ($0 * 30, $1 * 30) }
                            
                            DispatchQueue.main.async {
                                (mower, obstacles) = rescalePositions(tuplesPos, tuplesObs)
                            }
                        }
                    }
                }
            }
        }
        .padding(10)
    }
}

struct FlowMapView_Previews: PreviewProvider {
    static var previews: some View {
        FlowMapView()
    }
}
