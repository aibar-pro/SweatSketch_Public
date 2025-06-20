//
//  TopCornerRoundedBackgroundModifier.swift
//  SweatSketch
//
//  Created by aibaranchikov on 16.06.2025.
//

import SwiftUI

fileprivate struct TopCornerRoundedBackgroundModifier: ViewModifier {
    let color: Color
    var cornerRadius: CGFloat = Constants.Design.cornerRadius
    var contentPadding: CGFloat = Constants.Design.spacing
    
    func body(content: Content) -> some View {
        content
            .padding(contentPadding)
            .background(
                TopCornerRoundedShape(cornerRadius: cornerRadius)
                    .fill(color)
                    .ignoresSafeArea(edges: .bottom)
            )
    }
}

extension View {
    func roundedCornerBackground(_ color: Color) -> some View {
        self.modifier(TopCornerRoundedBackgroundModifier(color: color))
    }
}
