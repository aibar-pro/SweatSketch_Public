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
                ForEach(0..<totalSections, id: \.self) { section in
                    RoundedRectangle(cornerRadius: 8)
                        .padding(2)
                        .foregroundColor(section == currentSection ? WidgetConstants.Colors.backgroundStartColor : WidgetConstants.Colors.backgroundEndColor)
                        .frame(width: barGeometry.size.width / CGFloat(totalSections), height: barGeometry.size.height)
                        .offset(x: CGFloat(section)*(barGeometry.size.width / CGFloat(totalSections)))
                        .animation(.linear, value: currentSection)
                }
                
                RoundedRectangle(cornerRadius: 8)
                    .stroke(WidgetConstants.Colors.lowEmphasisColor)
                    .foregroundColor(Color.clear)
                    .frame(width: barGeometry.size.width, height: barGeometry.size.height)
            }
        }
        
//        GeometryReader { barGeometry in
//            ZStack(alignment: .leading) {
//                RoundedRectangle(cornerRadius: 8)
//                    .foregroundColor(WidgetConstants.Colors.supportColor)
//                    .frame(width: barGeometry.size.width, height: barGeometry.size.height)
//                
//                
//                RoundedRectangle(cornerRadius: 8)
//                    .foregroundColor(WidgetConstants.Colors.backgroundEndColor)
//                    .frame(width: (barGeometry.size.width / CGFloat(totalSections)) * CGFloat(currentSection+1), height: barGeometry.size.height)
//                    .animation(.linear, value: currentSection)
//                
//                if currentSection > 0 {
//                    RoundedRectangle(cornerRadius: 8)
//                        .foregroundColor(WidgetConstants.Colors.backgroundStartColor)
//                        .frame(width: (barGeometry.size.width / CGFloat(totalSections)) * CGFloat(currentSection), height: barGeometry.size.height)
//                        .animation(.linear, value: currentSection)
//                }
//                
//                RoundedRectangle(cornerRadius: 8)
//                    .stroke(WidgetConstants.Colors.lowEmphasisColor)
//                    .foregroundColor(Color.clear)
//                    .frame(width: barGeometry.size.width, height: barGeometry.size.height)
//            }
//        }
    }
}

//#Preview {
//    WidgetProgressBarView(totalSections: 10, currentSection: 5)
//}
