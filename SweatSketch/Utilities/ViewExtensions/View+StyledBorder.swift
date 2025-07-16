//
//  View+StyledBorder.swift
//  SweatSketch
//
//  Created by aibaranchikov on 27.06.2025.
//

import SwiftUI

extension View {
    public func styledBorder(
        _ color: Color? = nil,
        paddings: (horizontal: CGFloat, vertical: CGFloat)? = nil
    ) -> some View {
        self
            .padding(.vertical, paddings?.vertical ?? Constants.Design.spacing)
            .padding(.horizontal, paddings?.horizontal ?? Constants.Design.spacing)
            .background(
                RoundedRectangle(cornerRadius: Constants.Design.cornerRadius, style: .continuous)
                    .stroke(style: StrokeStyle(lineWidth: 2))
                    .foregroundColor(color ?? Constants.Design.Colors.elementFgPrimary)
            )
    }
}
