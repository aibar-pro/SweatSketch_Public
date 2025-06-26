//
//  View+Extensions.swift
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

extension View {
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
    
    func linkUnderline(color: Color) -> some View {
        padding(.bottom, 1).border(width: 1, edges: [.bottom], color: color)
    }
}

struct EdgeBorder: Shape {
    var width: CGFloat
    var edges: [Edge]

    func path(in rect: CGRect) -> Path {
        edges.map { edge -> Path in
            switch edge {
            case .top: return Path(.init(x: rect.minX, y: rect.minY, width: rect.width, height: width))
            case .bottom: return Path(.init(x: rect.minX, y: rect.maxY - width, width: rect.width, height: width))
            case .leading: return Path(.init(x: rect.minX, y: rect.minY, width: width, height: rect.height))
            case .trailing: return Path(.init(x: rect.maxX - width, y: rect.minY, width: width, height: rect.height))
            }
        }.reduce(into: Path()) { $0.addPath($1) }
    }
}
