//
//  SweatSketchWidgetLiveActivity.swift
//  SweatSketchWidget
//
//  Created by aibaranchikov on 16.04.2024.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct SweatSketchWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ActiveWorkoutActionAttributes.self) { context in
            ZStack {
                WidgetBackgroundView()
                
                VStack(alignment: .leading, spacing: WidgetConstants.padding * 2) {
                    WidgetActionInfoLabelView(
                        title: context.state.title,
                        quantity: context.state.quantity,
                        progress: context.state.progress
                    )
                    .font(.headline.weight(.bold))
                    .foregroundStyle(WidgetConstants.Colors.elementFgHighEmphasis)
                    
                    WidgetProgressBarView(
                        progress: context.state.progress,
                        stepIndex: context.state.stepIndex,
                        totalSteps: context.state.totalSteps
                    )
                    .frame(height: WidgetConstants.padding * 3)
                    
                    if #available(iOS 17.0, *) {
                        HStack(alignment: .top) {
                            Button(intent: ActiveWorkoutPreviousItemIntent()) {
                                Image(systemName: "chevron.backward")
                                    .padding(.vertical, WidgetConstants.padding)
                                    .padding(.horizontal, WidgetConstants.padding)
                                    
                            }
                            .tint(WidgetConstants.Colors.elementFgMediumEmphasis)
                            Spacer()
                            Button(intent: ActiveWorkoutNextItemIntent()) {
                                Image(systemName: "chevron.forward")
                                    .fontWeight(.bold)
                                    .padding(.vertical, WidgetConstants.padding)
                                    .padding(.horizontal, WidgetConstants.padding * 2)
                            }
                            .tint(WidgetConstants.Colors.elementFgAccent)
                        }
                    }
                }
                .padding(WidgetConstants.padding*2)
                
            }
            .activityBackgroundTint(WidgetConstants.Colors.elementFgPrimary)
            .activitySystemActionForegroundColor(WidgetConstants.Colors.elementFgPrimary)

        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.bottom) {
                    VStack (alignment: .leading, spacing: WidgetConstants.padding) {
                        WidgetActionInfoLabelView(
                            title: context.state.title,
                            quantity: context.state.quantity,
                            progress: context.state.progress
                        )
                        .font(.headline.bold())
                        .foregroundStyle(WidgetConstants.Colors.elementFgHighEmphasis)
                        
                        WidgetProgressBarView(
                            progress: context.state.progress,
                            stepIndex: context.state.stepIndex,
                            totalSteps: context.state.totalSteps
                        )
                        .frame(height: WidgetConstants.padding * 2)
                        
                        if #available(iOS 17.0, *) {
                            HStack(alignment: .top) {
                                Button(intent: ActiveWorkoutPreviousItemIntent()) {
                                    Image(systemName: "chevron.backward")
                                        .padding(.vertical, WidgetConstants.padding/2)
                                        .padding(.horizontal, WidgetConstants.padding/2)
                                }
                                .tint(WidgetConstants.Colors.elementFgMediumEmphasis)
                                Spacer()
                                Button(intent: ActiveWorkoutNextItemIntent()) {
                                    Image(systemName: "chevron.forward")
                                        .fontWeight(.bold)
                                        .padding(.vertical, WidgetConstants.padding/2)
                                        .padding(.horizontal, WidgetConstants.padding)
                                }
                                .tint(WidgetConstants.Colors.elementFgAccent)
                            }
                        }
                    }
                    .padding(.top, WidgetConstants.padding*2)
                }
            } compactLeading: {
                Image(systemName: context.state.iconName)
                    .foregroundStyle(WidgetConstants.Colors.elementFgPrimary)
                    .padding(.trailing, WidgetConstants.padding/2)
            } compactTrailing: {
                Text("\(context.state.title)")
                    .truncationMode(.tail)
                    .foregroundStyle(WidgetConstants.Colors.elementFgPrimary)
            } minimal: {
                Image(systemName: context.state.iconName)
                    .foregroundStyle(WidgetConstants.Colors.elementFgPrimary)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(WidgetConstants.Colors.elementFgPrimary)
        }
    }
}

extension ActiveWorkoutActivityState {
    static func getAction(isTimed: Bool = false) -> ActiveWorkoutActivityState {
        let names: [String] = ["Treadmill Run", "Bench Press", "Burpees", "Deadlift", "Calf Raises", "Rest"]
        let durations: [Int] = [1, 15, 60, 361, 7621]
        
        let totalSteps = [1, 11].randomElement() ?? 1
        let stepIndex = Int.random(in: 1...totalSteps) - 1
        
        return .init(
            title: names.randomElement() ?? "",
            quantity: Bool.random()
            ? String(durations.randomElement() ?? 0) + "-" + String(durations.randomElement() ?? 0)
                : "max",
            progress: 0.1,
            isRest: false,
            stepIndex: stepIndex,
            totalSteps: totalSteps
        )
    }
}

extension ActiveWorkoutActionAttributes {
    static var preview: ActiveWorkoutActionAttributes {
        ActiveWorkoutActionAttributes()
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
