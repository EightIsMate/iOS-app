//
//  IdleStateTracker.swift
//  Group_8_app
//
//  Created by Kyrollos Ceriacous on 2023-04-24.
//

import Foundation
import Combine

class IdleState: ObservableObject {
    @Published var isIdle: Bool = false

    private var idleTimer: Timer?

    func startIdleTimer() {
        idleTimer?.invalidate()
        idleTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            self?.isIdle = true
            print("I am idle")
        }
    }

    func stopIdleTimer() {
        idleTimer?.invalidate()
        idleTimer = nil
        isIdle = false
    }
}
