//
//  ControllerButtonsView.swift
//  Group_8_app
//
//  Created by Kyrollos Ceriacous on 2023-04-17.
//

import SwiftUI

struct ControllerButtonsView: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            LeftRightArrowsView()
            UpDownArrowsView()
            AutoMoveButtonView()
        }
    }
}

struct ControllerButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        ControllerButtonsView()
    }
}
