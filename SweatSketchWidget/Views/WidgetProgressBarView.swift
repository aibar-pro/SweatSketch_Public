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
    var duration: Int? = nil
    
    @State private var isAnimating = false
    
    var body: some View {
        GeometryReader { barGeometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: WidgetConstants.cornerRadius)
                    .foregroundStyle(WidgetConstants.Colors.lowEmphasisColor)
                    .frame(width: barGeometry.size.width, height: barGeometry.size.height)
                
                HStack(alignment: .center, spacing: WidgetConstants.padding / 2) {
                    ForEach(0..<totalSections, id: \.self) { section in
                        Group {
                            if section < currentSection {
                                RoundedRectangle(cornerRadius: WidgetConstants.cornerRadius)
                                    .foregroundStyle(WidgetConstants.Colors.accentColor.opacity(0.65))
                            }
                            if section == currentSection {
                                if let duration {
                                    ProgressView(
                                        timerInterval: Date()...Date().addingTimeInterval(Double(duration)),
                                        countsDown: false
                                    )
                                        .labelsHidden()
                                        .tint(WidgetConstants.Colors.accentColor)
                                        .scaleEffect(x: 1, y: 3, anchor: .center)
                                        .frame(height: barGeometry.size.height - WidgetConstants.padding * 2)
                                        .clipShape(RoundedRectangle(cornerRadius: WidgetConstants.cornerRadius))
                                } else {
                                    RoundedRectangle(cornerRadius: WidgetConstants.cornerRadius)
                                        .foregroundStyle(WidgetConstants.Colors.accentColor)
                                }
                            }
                            if section > currentSection {
                                RoundedRectangle(cornerRadius: WidgetConstants.cornerRadius)
                                    .foregroundStyle(WidgetConstants.Colors.backgroundEndColor)
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
