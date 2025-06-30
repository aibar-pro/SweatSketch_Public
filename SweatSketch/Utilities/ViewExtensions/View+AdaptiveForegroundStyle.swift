//
//  View+AdaptiveForegroundStyle.swift
//  SweatSketch
//
//  Created by aibaranchikov on 28.03.2024.
//

import SwiftUI

fileprivate struct AdaptiveForegroundStyle: ViewModifier {
    let color: Color
    
    func body(content: Content) -> some View {
        if #available(iOS 15.0, *) {
            content
                .foregroundStyle(color)
        } else {
            content
                .foregroundColor(color)
        }
    }
}

extension View {
    func adaptiveForegroundStyle(_ color: Color) -> some View {
        self.modifier(AdaptiveForegroundStyle(color: color))
    }
}
