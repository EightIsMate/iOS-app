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
    // let autoMoveState = AutoMoveState()

    func startIdleTimer() {
        idleTimer?.invalidate()
        idleTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            self?.isIdle = true
            print("I am idle")
            // should sent info to the mower?
        }
    }

    func stopIdleTimer() {
        idleTimer?.invalidate()
        idleTimer = nil
        isIdle = false
    }
}
