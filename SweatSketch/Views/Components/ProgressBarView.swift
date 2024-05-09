//
//  ProgressBarView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 15.04.2024.
//

import SwiftUI

struct ProgressBarView: View {
    @State var totalSections: Int
    var currentSection: Int
    
    @State private var isAnimating = false
    
    var body: some View {
        GeometryReader { barGeometry in
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: Constants.Design.cornerRadius)
                    .customForegroundColorModifier(Constants.Design.Colors.textColorlowEmphasis)
                    .frame(width: barGeometry.size.width, height: barGeometry.size.height)

                HStack (alignment: .center, spacing: Constants.Design.spacing/2) {
                    ForEach(0..<totalSections, id: \.self) { section in
                        RoundedRectangle(cornerRadius: Constants.Design.cornerRadius-Constants.Design.spacing/2)
                            .customForegroundColorModifier(section == currentSection ? Constants.Design.Colors.backgroundAccentColor : Constants.Design.Colors.backgroundEndColor)
                    }
                }
                .padding(.horizontal, Constants.Design.spacing/2)
                .padding(.vertical, Constants.Design.spacing/4)
            }
        }
    }
}

#Preview {
    ProgressBarView(totalSections: 3, currentSection: 2)
}
