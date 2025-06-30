//
//  View+If.swift
//  SweatSketch
//
//  Created by aibaranchikov on 25.06.2025.
//

import SwiftUICore

extension View {
    @ViewBuilder
    func `if`<TrueContent: View>(
        _ condition: Bool,
        transform: (Self) -> TrueContent
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

