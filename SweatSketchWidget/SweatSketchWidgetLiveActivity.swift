//
//  SweatSketchWidgetLiveActivity.swift
//  SweatSketchWidget
//
//  Created by aibaranchikov on 16.04.2024.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct SweatSketchWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var action: ActiveWorkoutActionModel
    }
    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct SweatSketchWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: SweatSketchWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            ZStack {
                WidgetBackgroundView()
                
                VStack (alignment: .leading) {
                    
                    WidgetActionInfoLabelView(action: context.state.action)
                    .font(.headline.bold())
                    .foregroundStyle(WidgetConstants.Colors.highEmphasisColor)
                    
                    WidgetProgressBarView(totalSections: context.state.action.totalActions, currentSection: context.state.action.currentAction)
                        .frame(height: 20)
                }
                .padding(16)
                
            }
            .activityBackgroundTint(WidgetConstants.Colors.backgroundStartColor)
            .activitySystemActionForegroundColor(WidgetConstants.Colors.supportColor)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Image(systemName: context.state.action.iconName)
                       .foregroundStyle(WidgetConstants.Colors.iconColor)
                       .padding(.leading, 16)
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    VStack (alignment: .leading) {
                        WidgetActionInfoLabelView(action: context.state.action)
                            .font(.headline.bold())
                            .foregroundStyle(WidgetConstants.Colors.highEmphasisColor)
                        
                        WidgetProgressBarView(totalSections: context.state.action.totalActions, currentSection: context.state.action.currentAction)
                            .frame(height: 20)
                    }
                    .padding(16)
                }
            } compactLeading: {
                Image(systemName: context.state.action.iconName)
                    .foregroundStyle(WidgetConstants.Colors.iconColor)
                    .padding(.trailing, 5)
            } compactTrailing: {
                Text("\(context.state.action.title)")
                    .truncationMode(.tail)
                    .foregroundStyle(WidgetConstants.Colors.iconColor)
            } minimal: {
                Image(systemName: context.state.action.iconName)
                    .foregroundStyle(WidgetConstants.Colors.iconColor)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(WidgetConstants.Colors.backgroundStartColor)
        }
    }
}

extension SweatSketchWidgetAttributes {
    fileprivate static var preview: SweatSketchWidgetAttributes {
        SweatSketchWidgetAttributes(name: "World")
    }
}

extension SweatSketchWidgetAttributes.ContentState {
    fileprivate static var action0: SweatSketchWidgetAttributes.ContentState {
        SweatSketchWidgetAttributes.ContentState(action: ActiveWorkoutActionModel(id: UUID(), title: "Treadmill Run", duration: 60, totalActions: 1, currentAction: 0))
     }
     
     fileprivate static var action1: SweatSketchWidgetAttributes.ContentState {
         SweatSketchWidgetAttributes.ContentState(action: ActiveWorkoutActionModel(id: UUID(), title: "Bench Press", repsCount: 12, totalActions: 4, currentAction: 2))
     }
    
    fileprivate static var action2: SweatSketchWidgetAttributes.ContentState {
        SweatSketchWidgetAttributes.ContentState(action: ActiveWorkoutActionModel(id: UUID(), title: "Bench Press", repsMax: true, totalActions: 2, currentAction: 1))
    }
    
    fileprivate static var action3: SweatSketchWidgetAttributes.ContentState {
        SweatSketchWidgetAttributes.ContentState(action: ActiveWorkoutActionModel(id: UUID(), title: "Deadlift", repsCount: 12, totalActions: 2, currentAction: 0))
    }
   
   fileprivate static var action4: SweatSketchWidgetAttributes.ContentState {
       SweatSketchWidgetAttributes.ContentState(action: ActiveWorkoutActionModel(id: UUID(), title: "Burpees", repsMax: true, totalActions: 2, currentAction: 1))
   }
}

#Preview("Notification", as: .content, using: SweatSketchWidgetAttributes.preview) {
   SweatSketchWidgetLiveActivity()
} contentStates: {
    SweatSketchWidgetAttributes.ContentState.action0
    SweatSketchWidgetAttributes.ContentState.action1
    SweatSketchWidgetAttributes.ContentState.action2
    SweatSketchWidgetAttributes.ContentState.action3
    SweatSketchWidgetAttributes.ContentState.action4
}
