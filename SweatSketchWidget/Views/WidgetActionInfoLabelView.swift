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
    var quantity: String
    var progress: Double
    
    var body: some View {
        HStack(alignment: .top, spacing: WidgetConstants.padding) {
            Text(title)
            Spacer()
            Text(quantity)
                .contentTransition(.numericText())
        }
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
