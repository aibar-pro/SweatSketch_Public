//
//  WidgetProgressBarView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 17.04.2024.
//

import SwiftUI

struct WidgetProgressBarView: View {
    var itemProgress: ItemProgress
    
    var body: some View {
        GeometryReader { barGeometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: WidgetConstants.cornerRadius)
                    .fill(WidgetConstants.Colors.elementBgSecondary)
                    .frame(width: barGeometry.size.width, height: barGeometry.size.height)
                
                HStack(alignment: .center, spacing: WidgetConstants.padding / 2) {
                    ForEach(0..<itemProgress.totalSteps, id: \.self) { step in
                        Group {
                            if step == itemProgress.stepIndex {
                                ProgressView(value: itemProgress.stepProgress.progress)
                                    .labelsHidden()
                                    .tint(WidgetConstants.Colors.elementFgAccent)
                                    .scaleEffect(x: 1, y: 3, anchor: .center)
                                    .frame(height: barGeometry.size.height - WidgetConstants.padding * 2)
                                    .clipShape(RoundedRectangle(cornerRadius: WidgetConstants.cornerRadius))
                            } else {
                                RoundedRectangle(cornerRadius: WidgetConstants.cornerRadius)
                                    .foregroundStyle(
                                        step < itemProgress.stepIndex
                                        ? WidgetConstants.Colors.elementFgPrimary
                                        : WidgetConstants.Colors.elementFgLowEmphasis
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
