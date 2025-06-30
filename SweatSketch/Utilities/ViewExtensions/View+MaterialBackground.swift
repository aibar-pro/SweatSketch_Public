//
//  View+MaterialBackground.swift
//  SweatSketch
//
//  Created by aibaranchikov on 28.02.2024.
//

import Foundation
import SwiftUI

fileprivate struct AdaptiveMaterialBackground<S: Shape>: ViewModifier {
    var shape: S
    var fallbackColor: Color
    var opacity: Double = 1
    
    func body(content: Content) -> some View {
        if #available(iOS 15.0, *) {
            content
                .background(.regularMaterial.opacity(opacity), in: shape)
        } else {
            content
                .background(shape.fill(fallbackColor.opacity(opacity)))
        }
    }
}

extension View {
    func materialBackground<S: Shape>(
        shape: S = RoundedRectangle(
            cornerRadius: Constants.Design.cornerRadius,
            style: .continuous
        ),
        fallbackColor: Color = Constants.Design.Colors.elementBgSecondary,
        opacity: Double = 1
    ) -> some View {
        modifier(
            AdaptiveMaterialBackground(
                shape: shape,
                fallbackColor: fallbackColor,
                opacity: opacity
            )
        )
    }
}

