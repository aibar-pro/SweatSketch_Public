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
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(WidgetConstants.Colors.lowEmphasisColor)
                    .frame(width: barGeometry.size.width, height: barGeometry.size.height)
                
                HStack (alignment: .center, spacing: 4) {
                    ForEach(0..<totalSections, id: \.self) { section in
                        RoundedRectangle(cornerRadius: 4)
                            .foregroundColor(section == currentSection ? WidgetConstants.Colors.accentColor : WidgetConstants.Colors.backgroundEndColor)
                    }
                }
                .padding(.horizontal, 4)
                .padding(.vertical, 4)
            }
        }
    }
}

//#Preview {
//    WidgetProgressBarView(totalSections: 10, currentSection: 5)
//}
