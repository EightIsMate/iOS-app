//
//  WebSocketClientSide.swift
//  Group_8_app
//
//  Created by Kyrollos Ceriacous on 2023-04-21.
//

import Foundation

class WebSocketHandler: NSObject, ObservableObject, URLSessionWebSocketDelegate {
    @Published var receivedMessage: String = ""
    @Published var isConnected: Bool = false

    private var webSocketTask: URLSessionWebSocketTask?
    
    func connect() {
        let url = URL(string: "ws://172.20.10.9:12345")!
        let webSocketSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        webSocketTask = webSocketSession.webSocketTask(with: url)
        webSocketTask?.resume()
    }
    
    func send(message: String) {
        guard webSocketTask?.state == .running else {
            print("WebSocket not running, unable to send message")
            return
        }
        
        webSocketTask?.send(.string(message)) { error in
            if let error = error {
                print("Failed to send message: \(error)")
            } else {
                print("Message sent successfully")
            }
        }
    }

    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("WebSocket connection opened")
        DispatchQueue.main.async {
            self.isConnected = true
        }
        // send(message: "Hello from SwiftUI app!")
        // receiveMessage()
    }


    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        DispatchQueue.main.async {
            self.isConnected = false
        }
    }


    func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    DispatchQueue.main.async {
                        self.receivedMessage = text
                    }
                    print("Received message: \(text)")
                default:
                    print("Unsupported message type")
                }
                if self.webSocketTask?.state == .running {
                    self.receiveMessage()
                } else {
                    print("WebSocket not running")
                    DispatchQueue.main.async {
                        self.isConnected = false
                    }
                }
            case .failure(let error):
                print("Failed to receive message: \(error)")
                if let urlError = error as? URLError, urlError.code == .cancelled {
                    print("WebSocket connection cancelled")
                } else {
                    print("WebSocket error occurred")
                }
                DispatchQueue.main.async {
                    self.isConnected = false
                }
            }
        }
    }
}


