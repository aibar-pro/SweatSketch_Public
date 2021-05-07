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
    let color: Color = Color.secondary.opacity(0.2)
    
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, Constants.Design.spacing*1.25)
            .padding(.vertical, Constants.Design.spacing*0.75)
            .background(
                ZStack {
//                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
//                        .stroke(Color.accentColor, lineWidth: 2)
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(color)
                }
            )
    }
}

extension View {
    func secondaryButtonLabelStyleModifier() -> some View {
        modifier(SecondaryButtonLabelStyleModifier())
    }
}
