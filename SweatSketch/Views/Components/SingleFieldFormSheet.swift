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
    case workoutRename
    case exerciseRename
    case addCollection
    case renameCollection
    case exerciseSetCount
    case username
    
    var config: SingleFieldFormConfig {
        switch self {
        case .workoutRename:
            return SingleFieldFormConfig(
                title: "workout.edit.rename.title",
                placeholder: "app.rename.placeholder",
                actionLabel: "app.button.rename.label"
            )
        case .exerciseRename:
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
        case .exerciseSetCount:
            return SingleFieldFormConfig(
                title: "exercise.edit.set.count.title",
                placeholder: "exercise.edit.set.count.placeholder",
                actionLabel: "app.button.save.label"
            )
        case .username:
            return SingleFieldFormConfig(
                title: "user.edit.username.title",
                placeholder: "user.edit.username.placeholder",
                actionLabel: "app.button.add.label"
            )
        }
    }
}

struct SingleFieldFormSheet: View {
    let kind: SingleFieldFormKind
    var config: SingleFieldFormConfig {
        kind.config
    }
    
    init(
        kind: SingleFieldFormKind,
        initialText: String = "",
        onSubmit: @escaping (String) -> Void,
        onCancel: @escaping () -> Void
    ) {
        self.kind = kind
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
                switch kind {
                case .exerciseSetCount:
                    IntegerTextField(
                        value: $text.asInt(minimum: 1),
                        placeholder: config.placeholder
                    )
                    .frame(width: 75)
                default:
                    TextField(config.placeholder, text: $text)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
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
        kind: .workoutRename,
        onSubmit: {_ in },
        onCancel: {}
    )
}
