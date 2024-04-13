//
//  ProgressBarView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 15.04.2024.
//

import SwiftUI

struct ProgressBarView: View {
    var totalSections: Int
    var currentSection: Int
    
    var body: some View {
        GeometryReader { barGeometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: Constants.Design.cornerRadius)
                    .foregroundColor(Constants.Design.Colors.buttonSecondaryBackgroundColor)
                    .frame(width: barGeometry.size.width, height: barGeometry.size.height)
                RoundedRectangle(cornerRadius: Constants.Design.cornerRadius)
                    .foregroundColor(Constants.Design.Colors.buttonPrimaryBackgroundColor)
                    .frame(width: (barGeometry.size.width / CGFloat(totalSections)) * CGFloat(currentSection + 1), height: barGeometry.size.height)
                    .animation(.linear, value: currentSection)
            }
        }
    }
}

#Preview {
    ProgressBarView(totalSections: 10, currentSection: 2)
}
