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
                        repsCount: context.state.repsCount,
                        repsMax: context.state.repsMax,
                        duration: context.state.duration
                    )
                    .font(.headline.bold())
                    .foregroundStyle(WidgetConstants.Colors.highEmphasisColor)
                    
                    WidgetProgressBarView(
                        totalSections: context.state.totalActions,
                        currentSection: context.state.currentAction,
                        duration: context.state.duration
                    )
                    .frame(height: WidgetConstants.padding * 3)
                    
                    if #available(iOS 17.0, *) {
                        HStack(alignment: .top) {
                            Button(intent: ActiveWorkoutPreviousItemIntent()) {
                                Image(systemName: "chevron.backward")
                                    .padding(.vertical, WidgetConstants.padding)
                                    .padding(.horizontal, WidgetConstants.padding)
                                    
                            }
                            .tint(WidgetConstants.Colors.mediumEmphasisColor)
                            Spacer()
                            Button(intent: ActiveWorkoutNextItemIntent()) {
                                Image(systemName: "chevron.forward")
                                    .fontWeight(.bold)
                                    .padding(.vertical, WidgetConstants.padding)
                                    .padding(.horizontal, WidgetConstants.padding*2)
                            }
                            .tint(WidgetConstants.Colors.highEmphasisColor)
                        }
                    }
                }
                .padding(WidgetConstants.padding*2)
                
            }
            .activityBackgroundTint(WidgetConstants.Colors.backgroundStartColor)
            .activitySystemActionForegroundColor(WidgetConstants.Colors.supportColor)

        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.bottom) {
                    VStack (alignment: .leading, spacing: WidgetConstants.padding) {
                        WidgetActionInfoLabelView(title: context.state.title, repsCount: context.state.repsCount, repsMax: context.state.repsMax, duration: context.state.duration)
                        .font(.headline.bold())
                        .foregroundStyle(WidgetConstants.Colors.highEmphasisColor)
                        
                        WidgetProgressBarView(
                            totalSections: context.state.totalActions,
                            currentSection: context.state.currentAction
                        )
                            .frame(height: WidgetConstants.padding * 2)
                        
                        if #available(iOS 17.0, *) {
                            HStack(alignment: .top) {
                                Button(intent: ActiveWorkoutPreviousItemIntent()) {
                                    Image(systemName: "chevron.backward")
                                        .padding(.vertical, WidgetConstants.padding/2)
                                        .padding(.horizontal, WidgetConstants.padding/2)
                                }
                                .tint(WidgetConstants.Colors.backgroundStartColor)
                                Spacer()
                                Button(intent: ActiveWorkoutNextItemIntent()) {
                                    Image(systemName: "chevron.forward")
                                        .fontWeight(.bold)
                                        .padding(.vertical, WidgetConstants.padding/2)
                                        .padding(.horizontal, WidgetConstants.padding)
                                }
                                .tint(WidgetConstants.Colors.accentColor)
                            }
                        }
                    }
                    .padding(.top, WidgetConstants.padding*2)
                }
            } compactLeading: {
                Image(systemName: context.state.iconName)
                    .foregroundStyle(WidgetConstants.Colors.iconColor)
                    .padding(.trailing, WidgetConstants.padding/2)
            } compactTrailing: {
                Text("\(context.state.title)")
                    .truncationMode(.tail)
                    .foregroundStyle(WidgetConstants.Colors.iconColor)
            } minimal: {
                Image(systemName: context.state.iconName)
                    .foregroundStyle(WidgetConstants.Colors.iconColor)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(WidgetConstants.Colors.backgroundStartColor)
        }
    }
}

extension ActiveWorkoutActivityState {
    static func getAction(isTimed: Bool = false) -> ActiveWorkoutActivityState {
        let names: [String] = ["Treadmill Run", "Bench Press", "Burpees", "Deadlift", "Calf Raises", "Rest"]
        let durations: [Int] = [1, 15, 60, 361, 7621]
        
        let totalActions = [1, 11].randomElement() ?? 1
        let currentAction = Int.random(in: 1...totalActions) - 1
        
        return .init(
            title: names.randomElement() ?? "",
            repsCount: Int16.random(in: 1...100),
            repsMax: Bool.random(),
            duration: isTimed ? durations.randomElement() ?? nil : nil,
            totalActions: totalActions,
            currentAction: currentAction
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
