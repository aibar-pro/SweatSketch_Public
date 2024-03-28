//
//  foregroundColorModifier.swift
//  SweatSketch
//
//  Created by aibaranchikov on 28.03.2024.
//

import SwiftUI

struct ForegroundSecondaryColorModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 15.0, *) {
            content
                .foregroundStyle(Constants.Design.Colors.textColorMediumEmphasis)
        } else {
            content
                .foregroundColor(Constants.Design.Colors.textColorMediumEmphasis)
        }
    }
}

extension View {
    func foregroundSecondaryColorModifier() -> some View {
        self.modifier(ForegroundSecondaryColorModifier())
    }
}
