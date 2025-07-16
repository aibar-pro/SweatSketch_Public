//
//  ProgressBarView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 15.04.2024.
//

import SwiftUI

struct ProgressBarView: View {
    var itemProgress: ItemProgress
    
    var body: some View {
        GeometryReader { barGeometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: Constants.Design.cornerRadius, style: .continuous)
                    .fill(Constants.Design.Colors.elementBgSecondary)
                
                HStack(alignment: .center, spacing: Constants.Design.spacing / 4) {
                    ForEach(0..<itemProgress.totalSteps, id: \.self) { step in
                        Group {
                            if step == itemProgress.stepIndex {
                                ProgressView(value: itemProgress.stepProgress.progress)
                                    .labelsHidden()
                                    .adaptiveTint(Constants.Design.Colors.elementFgAccent)
                                    .scaleEffect(
                                        x: 1,
                                        y: barGeometry.size.height / 3,
                                        anchor: .center
                                    )
                            } else {
                                Rectangle()
                                    .adaptiveForegroundStyle(
                                        step < itemProgress.stepIndex
                                        ? Constants.Design.Colors.elementFgPrimary
                                        : Constants.Design.Colors.elementFgLowEmphasis
                                    )
                            }
                        }
                        .frame(height: barGeometry.size.height)
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: Constants.Design.cornerRadius,
                                style: .continuous
                            )
                        )
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, Constants.Design.spacing / 4)
                .padding(.vertical, Constants.Design.spacing / 4)
            }
        }
    }
}

#Preview {
    ProgressBarView(
        itemProgress: .init(
            stepIndex: 4,
            totalSteps: 10,
            stepProgress: .init(
                progress: 0.67
            )
        )
    )
    .frame(height: 250)
    .background(Color.black)
}
