//
//  WidgetProgressBarView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 17.04.2024.
//

import SwiftUI

struct WidgetProgressBarView: View {
    var progress: Double
    var stepIndex: Int
    var totalSteps: Int
    
    @State private var isAnimating = false
    
    var body: some View {
        GeometryReader { barGeometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: WidgetConstants.cornerRadius)
                    .foregroundStyle(WidgetConstants.Colors.lowEmphasisColor)
                    .frame(width: barGeometry.size.width, height: barGeometry.size.height)
                
                HStack(alignment: .center, spacing: WidgetConstants.padding / 2) {
                    ForEach(0..<totalSteps, id: \.self) { step in
                        Group {
                            if step == stepIndex {
                                ProgressView(value: progress)
                                    .labelsHidden()
                                    .tint(WidgetConstants.Colors.accentColor)
                                    .scaleEffect(x: 1, y: 3, anchor: .center)
                                    .frame(height: barGeometry.size.height - WidgetConstants.padding * 2)
                                    .clipShape(RoundedRectangle(cornerRadius: WidgetConstants.cornerRadius))
                            } else {
                                RoundedRectangle(cornerRadius: WidgetConstants.cornerRadius)
                                    .foregroundStyle(
                                        step < stepIndex
                                        ? WidgetConstants.Colors.accentColor.opacity(0.65)
                                        : WidgetConstants.Colors.backgroundEndColor
                                    )
                            }
                        }
                    }
                }
                .padding(.horizontal, WidgetConstants.padding)
                .padding(.vertical, WidgetConstants.padding)
            }
        }
    }
}
