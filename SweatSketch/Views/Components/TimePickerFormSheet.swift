//
//  TimePickerFormSheet.swift
//  SweatSketch
//
//  Created by aibaranchikov on 28.03.2024.
//

import SwiftUI
    
struct TimePickerFormConfig{
    var title: LocalizedStringKey
}

enum TimePickerFormKind {
    case workout
    case exercise
    
    var config: TimePickerFormConfig {
        switch self {
        case .workout:
            return .init(title: "workout.edit.default.rest.time.title")
        case .exercise:
            return .init(title: "exercise.edit.rest.between.actions.title")
        }
    }
}

/*
 RectangleButton(
     content: {
         HStack(alignment: .lastTextBaseline, spacing: Constants.Design.spacing / 2) {
             Text(Constants.Placeholders.WorkoutCollection.customRestTimeText)
             Image(systemName: "arrow.up.right")
         }
     },
     style: .inline,
     action: {
         onSubmit(duration)
         onAdvancedEdit()
     }
 )
 */

struct TimePickerFormSheet<Content: View>: View {
    
    init(
        kind: TimePickerFormKind,
        initialDuration: Int,
        onSubmit: @escaping (_: Int) -> Void,
        onCancel: @escaping () -> Void,
        @ViewBuilder extraContent: @escaping () -> Content = { EmptyView() },
    ) {
        self.config = kind.config
        self.onSubmit = onSubmit
        self.onCancel = onCancel
        self.extraContent = extraContent
        _duration = State(initialValue: initialDuration)
    }
    
    private let config: TimePickerFormConfig
    private let onSubmit: (Int) -> Void
    private let onCancel: () -> Void
    private let extraContent: () -> Content

    @State var duration: Int = Constants.DefaultValues.restTimeDuration
    
    var body: some View {
        VStack (alignment: .leading, spacing: Constants.Design.spacing) {
            Text(config.title)
                .fullWidthText(.title3, isBold: true)
            
            VStack (alignment: .center, spacing: Constants.Design.spacing) {
                DurationPickerEditView(durationInSeconds: $duration, showHours: false, secondsInterval: 10)
                    .background(
                        RoundedRectangle(cornerRadius: Constants.Design.cornerRadius)
                            .stroke(Constants.Design.Colors.backgroundStartColor)
                    )
                    .frame(width: 250, height: 150)
                
                extraContent()
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
            buttonStackView
        }
    }
    
    private var buttonStackView: some View {
        HStack(spacing: Constants.Design.spacing) {
            RectangleButton(
                "app.button.cancel.label",
                style: .inline,
                action: {
                    onCancel()
                }
            )
            
            RectangleButton(
                "app.button.save.label",
                style: .primary,
                action: {
                    onSubmit(duration)
                }
            )
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

#Preview {
    TimePickerFormSheet(
        kind: .workout,
        initialDuration: 100500,
        onSubmit: { _ in
            
        },
        onCancel: {
            
        },
        extraContent: {
            Text("Preview")
        }
    )
}
