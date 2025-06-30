//
//  SingleFieldFormSheet.swift
//  SweatSketch
//
//  Created by aibaranchikov on 09.04.2024.
//

import SwiftUI

struct SingleFieldFormConfig {
    var title: LocalizedStringKey
    var placeholder: LocalizedStringKey
    var actionLabel: LocalizedStringKey
}

enum SingleFieldFormKind {
    case renameWorkout
    case renameExercise
    case addCollection
    case renameCollection
    
    var config: SingleFieldFormConfig {
        switch self {
        case .renameWorkout:
            return SingleFieldFormConfig(
                title: "workout.edit.rename.title",
                placeholder: "app.rename.placeholder",
                actionLabel: "app.button.rename.label"
            )
        case .renameExercise:
            return SingleFieldFormConfig(
                title: "exercise.edit.rename.title",
                placeholder: "app.rename.placeholder",
                actionLabel: "app.button.rename.label"
            )
        case .addCollection:
            return SingleFieldFormConfig(
                title: "collection.add.title",
                placeholder: "collection.add.placeholder",
                actionLabel: "app.button.rename.label"
            )
        case .renameCollection:
            return SingleFieldFormConfig(
                title: "collection.edit.rename.title",
                placeholder: "app.rename.placeholder",
                actionLabel: "app.button.rename.label"
            )
        }
    }
}

struct SingleFieldFormSheet: View {
    let config: SingleFieldFormConfig
    
    init(
        kind: SingleFieldFormKind,
        initialText: String = "",
        onSubmit: @escaping (String) -> Void,
        onCancel: @escaping () -> Void
    ) {
        self.config = kind.config
        _text = State(initialValue: initialText)
        self.onSubmit = onSubmit
        self.onCancel = onCancel
    }
    
    @State private var text: String
    
    var onSubmit: (String) -> Void
    var onCancel: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.Design.spacing) {
            Text(config.title)
                .fullWidthText(.title3, weight: .bold)
            
            HStack(alignment: .firstTextBaseline, spacing: Constants.Design.spacing / 2) {
                TextField(config.placeholder, text: $text)
                if !text.isEmpty {
                    IconButton(
                        systemImage: "xmark.circle",
                        style: .inlineTextField,
                        action: {
                            text.removeAll()
                        }
                    )
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .styledBorder()
            .adaptiveTint(Constants.Design.Colors.elementFgPrimary)
            
            buttonStackView
        }
    }
    
    private var buttonStackView: some View {
        HStack(spacing: Constants.Design.spacing) {
            RectangleButton(
                "app.button.cancel.label",
                style: .inline,
                action: {
                    text.removeAll()
                    onCancel()
                }
            )
            
            RectangleButton(
                config.actionLabel,
                style: .primary,
                isDisabled: Binding { text.isEmpty } set: { _ in },
                action: {
                    onSubmit(text)
                    text.removeAll()
                }
            )
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

#Preview {
    SingleFieldFormSheet(
        kind: .renameWorkout,
        onSubmit: {_ in },
        onCancel: {}
    )
}
