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
            LinearGradient(
                gradient: Gradient(
                    colors: [
                        WidgetConstants.Colors.screenBgStart,
                        WidgetConstants.Colors.screenBgEnd
                    ]
                ),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            RoundedRectangle(cornerRadius: WidgetConstants.cornerRadius, style: .continuous)
                .size(CGSize(width: 100, height: 50))
                .rotation(.degrees(10))
                .offset(x: 120, y: -5)
                .fill(WidgetConstants.Colors.screenBgAccent)
        }
    }
}

#Preview {
    WidgetBackgroundView()
}
