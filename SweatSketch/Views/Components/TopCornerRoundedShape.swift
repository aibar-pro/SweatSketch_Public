//
//  TopCornerRoundedShape.swift
//  
//
//  Created by aibaranchikov on 16.06.2025.
//

import SwiftUI

struct TopCornerRoundedShape: Shape {
    var cornerRadius: CGFloat = 16
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: 0, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height - cornerRadius))
        path.addArc(
            center: CGPoint(x: cornerRadius, y: cornerRadius),
            radius: cornerRadius,
            startAngle: Angle(degrees: 180),
            endAngle: Angle(degrees: 270),
            clockwise: false
        )
        path.addLine(to: CGPoint(x: rect.width - cornerRadius, y: 0))
        path.addArc(
            center: CGPoint(x: rect.width - cornerRadius, y: cornerRadius),
            radius: cornerRadius,
            startAngle: Angle(degrees: 90),
            endAngle: Angle(degrees: 0),
            clockwise: false
        )
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        
        path.closeSubpath()
        
        return path
    }
}

#Preview {
    TopCornerRoundedShape(cornerRadius: 25)
        .fill(Color.black)
        .ignoresSafeArea(edges: .bottom)
}
