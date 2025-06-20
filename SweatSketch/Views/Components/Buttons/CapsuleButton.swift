//
//  CapsuleButton.swift
//  SweatSketch
//
//  Created by aibaranchikov on 16.06.2025.
//

import SwiftUI

struct CapsuleButton<Content: View>: View {
    let action: () -> Void
    
    private let content: () -> Content
    let style: CustomButtonStyle
    var config: CustomButtonConfig { style.config }
    
    @Binding var isDisabled: Bool
    
    init(
        @ViewBuilder content: @escaping () -> Content,
        style: CustomButtonStyle,
        isDisabled: Binding<Bool> = .constant(false),
        action: @escaping () -> Void
    ) {
        self.action = action
        self.content = content
        self.style = style
        self._isDisabled = isDisabled
    }
    
    var body: some View {
        Button(action: action) {
            content()
                .font(config.isBold ? config.font.bold() : config.font)
                .customForegroundColorModifier(config.foregroundColor)
                .padding(
                    .horizontal,
                    style.isInline
                    ? Constants.Design.buttonLabelPaddding / 2
                    : Constants.Design.buttonLabelPaddding * 2
                )
                .padding(.vertical, Constants.Design.buttonLabelPaddding)
                .background(config.backgroundColor)
                .opacity(isDisabled ? 0.35 : 1)
                .contentShape(Capsule())
                .clipShape(Capsule())
                .shadow(radius: config.hasShadow ? config.shadowRadius : 0)
        }
        .disabled(isDisabled)
    }
}

extension CapsuleButton where Content == Text {
    init(
        _ title: LocalizedStringKey,
        style: CustomButtonStyle,
        isDisabled: Binding<Bool> = .constant(false),
        action: @escaping () -> Void
    ) {
        self.init(
            content: { Text(title) },
            style: style,
            isDisabled: isDisabled,
            action: action
        )
    }
}
