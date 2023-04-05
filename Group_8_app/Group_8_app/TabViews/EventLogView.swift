//
//  EventLogView.swift
//  Group_8_app
//
//  Created by Kyrollos Ceriacous on 2023-04-05.
//

import SwiftUI

struct EventLogView: View {
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 200, height: 200)
                .foregroundColor(.green)
            Text("\("Event log")")
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .bold))
        }
    }
}

struct EventLogView_Previews: PreviewProvider {
    static var previews: some View {
        EventLogView()
    }
}
