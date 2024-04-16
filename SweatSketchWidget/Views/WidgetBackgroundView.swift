//
//  WidgetBackgroundView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 16.04.2024.
//

import SwiftUI

struct WidgetBackgroundView: View {
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [WidgetConstants.Colors.backgroundStartColor, WidgetConstants.Colors.backgroundEndColor]), startPoint: .topLeading, endPoint: .bottomTrailing)
            
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .size(CGSize(width: 100, height: 50))
                .rotation(.degrees(10))
                .offset(x: 120, y: -5)
                .fill(WidgetConstants.Colors.accentColor)
        }
    }
}

#Preview {
    WidgetBackgroundView()
}

//#Preview("Notification",as: .content, using: ) {
//    WidgetBackgroundView()
//}
