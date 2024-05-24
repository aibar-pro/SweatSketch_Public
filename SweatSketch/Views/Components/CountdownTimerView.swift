//
//  CountdownTimeView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 15.04.2024.
//

import SwiftUI

struct CountdownTimerView: View {
    var timeRemaining: Int
    
    var body: some View {
        HStack (alignment: .center, spacing: Constants.Design.spacing/2) {
            Image(systemName: "timer")
            
            CountdownTimerLabelView(timeRemaining: timeRemaining)
        }
    }
}

#Preview {
    CountdownTimerView(timeRemaining: 5)
}
