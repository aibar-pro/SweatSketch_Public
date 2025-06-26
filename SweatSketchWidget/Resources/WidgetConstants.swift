//
//  WidgetConstants.swift
//  SweatSketch
//
//  Created by aibaranchikov on 17.04.2024.
//

import SwiftUI

enum WidgetConstants {
    enum Colors {
        static let screenBgStart = Color.bgGradientStart.opacity(0.87)
        static let screenBgEnd = Color.bgGradientEnd.opacity(0.87)
        static let screenBgAccent = Color.bgAccent.opacity(0.87)

        static let elementBgAccent = Color.accent.opacity(0.87)
        static let elementBgPrimary = Color.bgGradientStart.opacity(0.87)
        static let elementBgSecondary = Color.bgSecondaryElement.opacity(0.87)

        static let elementFgAccent = Color.accent.opacity(0.87)
        static let elementFgPrimary = Color.bgGradientStart.opacity(0.87)
        static let elementFgHighEmphasis = Color.primary.opacity(0.87)
        static let elementFgMediumEmphasis = Color.primary.opacity(0.6)
        static let elementFgLowEmphasis = Color.primary.opacity(0.1)
        static let elementFgLink = Color.fgLink.opacity(0.87)
    }
    
    static let padding = CGFloat(8)
    static let cornerRadius = CGFloat(8)
}
