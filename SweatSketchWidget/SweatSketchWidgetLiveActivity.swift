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
                
                VStack (alignment: .leading, spacing: WidgetConstants.padding*1.5) {
                    WidgetActionInfoLabelView(title: context.state.title, repsCount: context.state.repsCount, repsMax: context.state.repsMax, duration: context.state.duration)
                    .font(.headline.bold())
                    .foregroundStyle(WidgetConstants.Colors.highEmphasisColor)
                    
                    WidgetProgressBarView(totalSections: context.state.totalActions, currentSection: context.state.currentAction)
                        .frame(height: WidgetConstants.padding*3)
                    
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
                        
                        WidgetProgressBarView(totalSections: context.state.totalActions, currentSection: context.state.currentAction)
                            .frame(height: WidgetConstants.padding*2)
                        
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

extension ActiveWorkoutActionAttributes.ActiveWorkoutActionStatus {
    fileprivate static var action0: ActiveWorkoutActionAttributes.ActiveWorkoutActionStatus {
        ActiveWorkoutActionAttributes.ActiveWorkoutActionStatus(title: "Treadmill Run", duration: 60, totalActions: 1, currentAction: 0)
     }
     
     fileprivate static var action1: ActiveWorkoutActionAttributes.ActiveWorkoutActionStatus {
         ActiveWorkoutActionAttributes.ActiveWorkoutActionStatus(title: "Bench Press", repsCount: 12, totalActions: 4, currentAction: 2)
     }
    
    fileprivate static var action2: ActiveWorkoutActionAttributes.ActiveWorkoutActionStatus {
        ActiveWorkoutActionAttributes.ActiveWorkoutActionStatus(title: "Bench Press", repsMax: true, totalActions: 4, currentAction: 3)
    }
    
    fileprivate static var action3: ActiveWorkoutActionAttributes.ActiveWorkoutActionStatus {
        ActiveWorkoutActionAttributes.ActiveWorkoutActionStatus(title: "Deadlift", repsCount: 12, totalActions: 2, currentAction: 0)
    }
   
   fileprivate static var action4: ActiveWorkoutActionAttributes.ActiveWorkoutActionStatus {
       ActiveWorkoutActionAttributes.ActiveWorkoutActionStatus(title: "Burpees", repsMax: true, totalActions: 2, currentAction: 1)
   }
}

extension ActiveWorkoutActionAttributes {
    fileprivate static var preview: ActiveWorkoutActionAttributes {
        ActiveWorkoutActionAttributes()
    }
}

#Preview("Notification", as: .content, using: ActiveWorkoutActionAttributes.preview) {
   SweatSketchWidgetLiveActivity()
} contentStates: {
    ActiveWorkoutActionAttributes.ContentState.action0
    ActiveWorkoutActionAttributes.ContentState.action1
    ActiveWorkoutActionAttributes.ContentState.action2
    ActiveWorkoutActionAttributes.ContentState.action3
    ActiveWorkoutActionAttributes.ContentState.action4
}
