//
//  CountdownTimerLabelView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 24.05.2024.
//

import SwiftUI

struct CountdownTimerLabelView: View {
    @State private var isOver = false
    
    var timeRemaining: Int
    
    var body: some View {
        Group {
            if isOver {
                Text("0:00")
            } else {
                Text(
                    Date(
                        timeIntervalSinceNow: TimeInterval(timeRemaining)
                    ),
                    style: .timer
                )
            }
        }
        .multilineTextAlignment(.trailing)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(timeRemaining)) {
                self.isOver = true
            }
        }
    }
}
