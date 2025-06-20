//
//  PrimaryButtonLabelModifier.swift
//  SweatSketch
//
//  Created by aibaranchikov on 02.03.2024.
//

import Foundation
import SwiftUI

fileprivate struct PrimaryButtonLabelStyleModifier: ViewModifier {
    let cornerRadius: CGFloat = Constants.Design.cornerRadius
    let color: Color = Constants.Design.Colors.buttonPrimaryBackgroundColor
    
    func body(content: Content) -> some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        
        content
            .padding(.horizontal, Constants.Design.spacing * 1.25)
            .padding(.vertical, Constants.Design.spacing * 0.75)
            .background(
                shape
                    .fill(color)
            )
            .clipShape(shape)
            .contentShape(shape)
    }
}

extension View {
    func primaryButtonLabelStyleModifier() -> some View {
        modifier(PrimaryButtonLabelStyleModifier())
    }
}
