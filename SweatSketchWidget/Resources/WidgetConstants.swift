//
//  WidgetConstants.swift
//  SweatSketch
//
//  Created by aibaranchikov on 17.04.2024.
//

import SwiftUI

enum WidgetConstants {
    enum Colors {
        static let accentColor = Color("background_accent_color").opacity(0.87)
        static let backgroundStartColor = Color("background_gradient_start").opacity(0.87)
        static let backgroundEndColor = Color("background_gradient_end").opacity(0.87)
        static let iconColor = Color("icon_color").opacity(0.87)
        static let supportColor = Color.secondary.opacity(0.05)
        static let highEmphasisColor = Color.primary.opacity(0.87)
        static let mediumEmphasisColor = Color.primary.opacity(0.6)
        static let lowEmphasisColor = Color.primary.opacity(0.1)
    }
}
