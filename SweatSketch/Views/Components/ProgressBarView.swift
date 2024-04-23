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
            ForEach(0..<totalSections, id: \.self) { section in
                RoundedRectangle(cornerRadius: Constants.Design.cornerRadius)
                    .padding(Constants.Design.spacing/10)
                    .foregroundColor(section == currentSection ? Constants.Design.Colors.buttonPrimaryBackgroundColor : Constants.Design.Colors.backgroundEndColor)
                    .frame(width: barGeometry.size.width / CGFloat(totalSections), height: barGeometry.size.height)
                    .offset(x: CGFloat(section)*(barGeometry.size.width / CGFloat(totalSections)))
                    .animation(.linear, value: currentSection)
            }
        }
    }
}

#Preview {
    ProgressBarView(totalSections: 10, currentSection: 2)
}
