//
//  CountdownTimerLabelView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 24.05.2024.
//

import SwiftUI

struct CountdownTimerLabelView: View {
    var timeRemaining: Int
    
    var body: some View {
        Text(
            Date(
                timeIntervalSinceNow: TimeInterval(timeRemaining)
            ),
            style: .timer
        )
        .multilineTextAlignment(.trailing)
    }
}

#Preview {
    CountdownTimerLabelView(timeRemaining: 3)
}
