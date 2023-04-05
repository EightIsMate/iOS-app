//
//  SettingsView.swift
//  Group_8_app
//
//  Created by Kyrollos Ceriacous on 2023-04-05.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 200, height: 200)
                .foregroundColor(.purple)
            Text("\("Settings")")
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .bold))
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
