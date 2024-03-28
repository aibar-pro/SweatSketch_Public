//
//  ButtonLabelStyleModifier.swift
//  SweatSketch
//
//  Created by aibaranchikov on 28.02.2024.
//

import Foundation
import SwiftUI

struct AccentButtonLabelStyleModifier: ViewModifier {
    
    let cornerRadius: CGFloat = Constants.Design.cornerRadius
    let color: Color = Constants.Design.Colors.buttonAccentBackgroundColor
    
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, Constants.Design.spacing*1.5)
            .padding(.vertical, Constants.Design.spacing)
            .foregroundColor(Constants.Design.Colors.textColorHighEmphasis)
            .font(.title3.weight(.bold))
            .background(
                ZStack {
//                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
//                        .stroke(Constants.Design.Colors.textColorHighEmphasis, lineWidth: 2)
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(color)
                }
            )
            
    }
}

extension View {
    func accentButtonLabelStyleModifier() -> some View {
        modifier(AccentButtonLabelStyleModifier())
    }
}
