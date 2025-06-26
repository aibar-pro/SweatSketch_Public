//
//  RectangleButton.swift
//  SweatSketch
//
//  Created by aibaranchikov on 16.06.2025.
//

import SwiftUI

struct RectangleButton<Content: View>: View {
    let action: () -> Void
    
    private let content: () -> Content
    let style: CustomButtonStyle
    var config: CustomButtonConfig { style.config }
    
    let cornerRadius: CGFloat
    let isFullWidth: Bool
    
    @Binding var isDisabled: Bool
    
    init(@ViewBuilder content: @escaping () -> Content,
         style: CustomButtonStyle,
         cornerRadius: CGFloat = Constants.Design.cornerRadius,
         isFullWidth: Bool = false,
         isDisabled: Binding<Bool> = .constant(false),
         action: @escaping () -> Void) {
        self.action = action
        self.content = content
        self.style = style
        self.cornerRadius = cornerRadius
        self.isFullWidth = isFullWidth
        self._isDisabled = isDisabled
    }
    
    var body: some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        
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
                .frame(maxWidth: isFullWidth ? .infinity : nil)
                .if(style != .secondary) {
                    $0.background(
                        shape
                            .fill(config.backgroundColor)
                    )
                }
                .if(style == .secondary) {
                    $0.materialBackground(shape: shape)
                }
                .opacity(isDisabled ? 0.35 : 1)
                .clipShape(shape)
                .contentShape(shape)
                .if(config.hasShadow) {
                    $0.lightShadow(radius: config.shadowRadius)
                }
        }
        .disabled(isDisabled)
    }
}

extension RectangleButton where Content == Text {
    init(
        _ title: LocalizedStringKey,
        style: CustomButtonStyle,
        cornerRadius: CGFloat = Constants.Design.cornerRadius,
        isFullWidth: Bool = false,
        isDisabled: Binding<Bool> = .constant(false),
        action: @escaping () -> Void
    ) {
        self.init(
            content: { Text(title) },
            style: style,
            cornerRadius: cornerRadius,
            isFullWidth: isFullWidth,
            isDisabled: isDisabled,
            action: action
        )
    }
}
