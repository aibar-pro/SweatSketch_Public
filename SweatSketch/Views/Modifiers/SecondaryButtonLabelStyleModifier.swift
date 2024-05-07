//
//  SecondaryButtonLabelStyleModifier.swift
//  SweatSketch
//
//  Created by aibaranchikov on 02.03.2024.
//

import Foundation
import SwiftUI

struct SecondaryButtonLabelStyleModifier: ViewModifier {
    
    let cornerRadius: CGFloat = Constants.Design.cornerRadius
    let color: Color = Constants.Design.Colors.buttonSecondaryBackgroundColor
    
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, Constants.Design.spacing*1.25)
            .padding(.vertical, Constants.Design.spacing*0.75)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(color)
            )
    }
}

extension View {
    func secondaryButtonLabelStyleModifier() -> some View {
        modifier(SecondaryButtonLabelStyleModifier())
    }
}
