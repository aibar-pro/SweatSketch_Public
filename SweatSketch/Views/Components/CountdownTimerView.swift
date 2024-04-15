//
//  CountdownTimeView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 15.04.2024.
//

import SwiftUI

struct CountdownTimerView: View {
    
    @Binding var timeRemaining: Int
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        HStack (alignment: .center, spacing: Constants.Design.spacing/2) {
            Image(systemName: "timer")
            DurationView(durationInSeconds: timeRemaining)
                .onReceive(timer) { time in
                    if timeRemaining > 0 {
                        timeRemaining -= 1
                    }
                }
        }
    }
}

#Preview {
    CountdownTimerView(timeRemaining: .constant(100))
}
