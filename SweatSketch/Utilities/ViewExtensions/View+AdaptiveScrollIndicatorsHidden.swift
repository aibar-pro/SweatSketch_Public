//
//  View+AdaptiveScrollIndicatorsHidden.swift
//  SweatSketch
//
//  Created by aibaranchikov on 01.07.2025.
//

import SwiftUICore

extension View {
    func adaptiveScrollIndicatorsHidden() -> some View {
        if #available(iOS 16.0, *) {
            return self.scrollIndicators(.hidden)
        } else {
            return self
        }
    }
}
