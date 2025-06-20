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
    
    @State private var isOver = false
    
    var body: some View {
        HStack(alignment: .top) {
            Text(title)
            Spacer()

            if let duration {
                timerView(timeRemaining: duration)
            } else if isRepsMax {
                Text("x\(LocalizedStringResource("MAX"))")
            } else if let reps = repsCount {
                Text("x\(reps)")
            }
        }
    }
    
    private func timerView(timeRemaining: Int) -> some View {
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
    
    private var isRepsMax: Bool {
        repsMax ?? false
    }
}

#Preview(
    "Notification",
    as: .content,
    using: ActiveWorkoutActionAttributes.preview) {
   SweatSketchWidgetLiveActivity()
} contentStates: {
    ActiveWorkoutActivityState.getAction()
    ActiveWorkoutActivityState.getAction(isTimed: true)
    ActiveWorkoutActivityState.getAction(isTimed: true)
    ActiveWorkoutActivityState.getAction()
    ActiveWorkoutActivityState.getAction()
}
