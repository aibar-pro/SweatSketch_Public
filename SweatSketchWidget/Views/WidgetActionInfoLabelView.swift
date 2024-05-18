//
//  WidgetActionInfoLabelView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 17.04.2024.
//

import SwiftUI
import WidgetKit

struct WidgetActionInfoLabelView: View {
    var title: String
    var repsCount: Int16?
    var repsMax: Bool?
    var duration: Int?
    
    var body: some View {
        
        HStack(alignment: .top) {
            Text(title)
            Spacer()

            if let duration = duration {
                CountdownTimerLabelView(timeRemaining: duration)
            } else if let maximumRepetitions = repsMax, maximumRepetitions {
                Text("xMAX")
            } else if let reps = repsCount {
                Text("x\(reps)")
            }
        }
    }
}
