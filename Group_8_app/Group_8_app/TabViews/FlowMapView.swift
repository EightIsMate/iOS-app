//
//  FlowMapView.swift
//  Group_8_app
//
//  Created by Kyrollos Ceriacous on 2023-04-05.
//

import SwiftUI

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
    
    @State private var text = "Loading..."
    
    var body: some View {
        VStack {
            Text(text)
            ZStack {
                Circle()
                    .frame(width: 200, height: 200)
                    .foregroundColor(.red)
                Text("\("Flow map")")
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .bold))
            }
        }.onAppear {
            APICall { text in self.text = text ?? "Error"}
        }
    }
}

struct FlowMapView_Previews: PreviewProvider {
    static var previews: some View {
        FlowMapView()
    }
}
