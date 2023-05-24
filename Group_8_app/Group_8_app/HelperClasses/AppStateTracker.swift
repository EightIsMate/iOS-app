//
//  AppStateTracker.swift
//  Group_8_app
//
//  Created by Kyrollos Ceriacous on 2023-04-25.
//

import Foundation

class AppStateTracker: ObservableObject {
    @Published var autoMoveState = AutoMoveState()
    @Published var idleState: IdleState

    init() {
        let idleState = IdleState.createWithAppState(self)
        self.idleState = idleState
    }
}

