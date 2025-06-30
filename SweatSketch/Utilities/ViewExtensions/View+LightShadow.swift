//
//  View+LightShadow.swift
//  SweatSketch
//
//  Created by aibaranchikov on 26.06.2025.
//

import SwiftUICore

extension View {
    func lightShadow(
        paddingEdges: Edge.Set = .all,
        radius: CGFloat = 2
    ) -> some View {
        shadow(
            color: Constants.Design.Colors.elementFgLowEmphasis,
            radius: radius
        )
        .padding(paddingEdges, radius)
    }
}
