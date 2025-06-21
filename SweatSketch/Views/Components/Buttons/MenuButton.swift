//
//  MenuButton.swift
//  SweatSketch
//
//  Created by aibaranchikov on 18.06.2025.
//

import SwiftUI

struct MenuButton<Content: View>: View {
    let content: () -> Content
    let style: CustomButtonStyle
    var config: CustomButtonConfig { style.config }
    
    var imageName: String {
        if style.isInline {
            return "ellipsis"
        } else {
            return "ellipsis.circle"
        }
    }
    
    @Binding var isDisabled: Bool
    
    init(style: CustomButtonStyle,
         isDisabled: Binding<Bool> = .constant(false),
         @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.style = style
        self._isDisabled = isDisabled
    }
    
    var body: some View {
        Menu {
            content()
        } label: {
            Image(systemName: imageName)
                .font(config.isBold ? config.font.bold() : config.font)
                .customForegroundColorModifier(config.foregroundColor)
                .padding(.horizontal, Constants.Design.buttonLabelPaddding)
                .padding(.vertical, Constants.Design.buttonLabelPaddding)
                .background(config.backgroundColor)
                .opacity(isDisabled ? 0.35 : 1)
                .contentShape(Circle())
                .clipShape(Circle())
                .shadow(radius: config.hasShadow ? config.shadowRadius : 0)
        }
        .disabled(isDisabled)
    }
}

#Preview {
    MenuButton(style: .accent) {
        Button("Test") {
            
        }
    }
}
