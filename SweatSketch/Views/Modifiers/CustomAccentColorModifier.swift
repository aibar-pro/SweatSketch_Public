//
//  CustomAccentColorModifier.swift
//  SweatSketch
//
//  Created by aibaranchikov on 19.07.2024.
//

import SwiftUI

fileprivate struct CustomAccentColorModifier: ViewModifier {
    let color: Color
    
    func body(content: Content) -> some View {
        if #available(iOS 15.0, *) {
            content
                .tint(color)
        } else {
            content
                .accentColor(color)
        }
    }
}

extension View {
    func customAccentColorModifier(_ color: Color) -> some View {
        self.modifier(CustomAccentColorModifier(color: color))
    }
}
