//
//  WidgetProgressBarView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 17.04.2024.
//

import SwiftUI

struct WidgetProgressBarView: View {
    var totalSections: Int
    var currentSection: Int
    
    @State private var isAnimating = false
    
    var body: some View {
        GeometryReader { barGeometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: WidgetConstants.cornerRadius)
                    .foregroundColor(WidgetConstants.Colors.lowEmphasisColor)
                    .frame(width: barGeometry.size.width, height: barGeometry.size.height)
                
                HStack (alignment: .center, spacing: WidgetConstants.padding/2) {
                    ForEach(0..<totalSections, id: \.self) { section in
                        RoundedRectangle(cornerRadius: WidgetConstants.cornerRadius/2)
                            .foregroundColor(section == currentSection ? WidgetConstants.Colors.accentColor : WidgetConstants.Colors.backgroundEndColor)
                    }
                }
                .padding(.horizontal, WidgetConstants.padding/2)
                .padding(.vertical, WidgetConstants.padding/2)
            }
        }
    }
}
