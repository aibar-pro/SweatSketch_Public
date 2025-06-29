//
//  IconButton.swift
//  SweatSketch
//
//  Created by aibaranchikov on 16.06.2025.
//

import SwiftUI

struct IconButton: View {
    let systemImage: String
    let action: () -> Void
    let style: CustomButtonStyle
    var config: CustomButtonConfig {
        style.config
    }
    
    @Binding var isDisabled: Bool
    
    init(systemImage: String,
         style: CustomButtonStyle,
         isDisabled: Binding<Bool> = .constant(false),
         action: @escaping () -> Void) {
        self.action = action
        self.systemImage = systemImage
        self.style = style
        self._isDisabled = isDisabled
    }
    
    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(config.isBold ? config.font.bold() : config.font)
                .adaptiveForegroundStyle(config.foregroundColor)
                .padding(
                    .horizontal,
                    style == .inlineTextField ? 0 : Constants.Design.buttonLabelPaddding
                )
                .padding(
                    .vertical,
                    style == .inlineTextField ? 0 : Constants.Design.buttonLabelPaddding
                )
                .if(style != .secondary) {
                    $0.background(config.backgroundColor)
                }
                .if(style == .secondary) {
                    $0.materialBackground(shape: Circle())
                }
                .opacity(isDisabled ? 0.35 : 1)
                .contentShape(Circle())
                .clipShape(Circle())
                .if(config.hasShadow) {
                    $0.lightShadow(radius: config.shadowRadius)
                }
        }
        .disabled(isDisabled)
    }
}

#Preview {
    IconButton(
        systemImage: "checkmark",
        style: .accent,
        isDisabled: .constant(true),
        action: {}
    )
}
