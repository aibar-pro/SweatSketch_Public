//
//  WidgetActionInfoLabelView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 17.04.2024.
//

import SwiftUI

struct WidgetActionInfoLabelView: View {
    let action: ActiveWorkoutActionModel
    
    var body: some View {
        
        HStack(alignment: .top) {
            Text(action.title)
            Spacer()
            if let duration = action.duration {
                HStack (alignment: .center) {
                    Image(systemName: "timer")
                    DurationView(durationInSeconds: duration)
                }
            } else if let maximumRepetitions = action.repsMax, maximumRepetitions {
                Text("xMAX")
            } else if let reps = action.repsCount {
                Text("x\(reps)")
            }
        }
    }
}

#Preview {
    WidgetActionInfoLabelView(action: ActiveWorkoutActionModel(id: UUID(), title: "Untitled", totalActions: 10, currentAction: 6))
}
