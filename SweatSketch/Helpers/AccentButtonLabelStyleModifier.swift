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
    let color: Color = Constants.Design.Colors.buttonBackgroundColor
    
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, Constants.Design.spacing*1.5)
            .padding(.vertical, Constants.Design.spacing)
            .foregroundColor(.primary.opacity(0.8))
            .font(.title3.weight(.semibold))
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(color)
            )
            
    }
}

extension View {
    func accentButtonLabelStyleModifier() -> some View {
        modifier(AccentButtonLabelStyleModifier())
    }
}
