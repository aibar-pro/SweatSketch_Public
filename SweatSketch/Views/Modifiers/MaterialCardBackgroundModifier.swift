//
//  CardBackgroundModifier.swift
//  SweatSketch
//
//  Created by aibaranchikov on 28.02.2024.
//

import Foundation
import SwiftUI

struct MaterialCardBackgroundModifier: ViewModifier {
    
    let cornerRadius: CGFloat = Constants.Design.cornerRadius
    
    func body(content: Content) -> some View {
        if #available(iOS 15.0, *) {
            content
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        } else {
            content
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(
                        Color.secondary.opacity(0.2))
                )
                
        }
    }
}

extension View {
    func materialCardBackgroundModifier() -> some View {
        modifier(MaterialCardBackgroundModifier())
    }
}


