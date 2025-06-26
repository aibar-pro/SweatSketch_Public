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
                .lineLimit(1)
                .if(style == .inlineLink) {
                    $0.linkUnderline(color: config.foregroundColor)
                }
                .adaptiveForegroundStyle(config.foregroundColor)
                .padding(
                    .horizontal,
                    style.isInline
                    ? Constants.Design.buttonLabelPaddding / 2
                    : Constants.Design.buttonLabelPaddding * 2
                )
                .padding(.vertical, Constants.Design.buttonLabelPaddding)
                .if(style != .secondary) {
                    $0.background(config.backgroundColor)
                }
                .if(style == .secondary) {
                    $0.materialBackground(shape: Capsule())
                }
                .opacity(isDisabled ? 0.35 : 1)
                .contentShape(Capsule())
                .clipShape(Capsule())
                .if(config.hasShadow) {
                    $0.lightShadow(radius: config.shadowRadius)
                }
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
