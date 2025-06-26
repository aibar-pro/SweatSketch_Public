//
//  CustomButtonConfig.swift
//  
//
//  Created by aibaranchikov on 16.06.2025.
//

import SwiftUI

struct CustomButtonConfig {
    let font: Font
    let isBold: Bool
    let foregroundColor: Color
    let backgroundColor: Color
    let hasShadow: Bool
    let shadowRadius: CGFloat
}

enum CustomButtonStyle {
    case accent
    case primary
    case secondary
    case inline
    case inlineLink
    case inlineTextField
    
    var config: CustomButtonConfig {
        switch self {
        case .accent:
            return CustomButtonConfig(
                font: .title3,
                isBold: true,
                foregroundColor: Constants.Design.Colors.elementFgHighEmphasis,
                backgroundColor: Constants.Design.Colors.elementBgAccent,
                hasShadow: true,
                shadowRadius: 4
            )
        case .primary:
            return CustomButtonConfig(
                font: .body,
                isBold: true,
                foregroundColor: Constants.Design.Colors.elementFgHighEmphasis,
                backgroundColor: Constants.Design.Colors.elementBgPrimary,
                hasShadow: true,
                shadowRadius: 2
            )
        case .secondary:
            return CustomButtonConfig(
                font: .body,
                isBold: false,
                foregroundColor: Constants.Design.Colors.elementFgHighEmphasis,
                backgroundColor: Constants.Design.Colors.elementBgSecondary,
                hasShadow: true,
                shadowRadius: 2
            )
        case .inline:
            return CustomButtonConfig(
                font: .body,
                isBold: false,
                foregroundColor: .primary,
                backgroundColor: .clear,
                hasShadow: false,
                shadowRadius: 2
            )
        case .inlineLink:
            return CustomButtonConfig(
                font: .body,
                isBold: true,
                foregroundColor: Constants.Design.Colors.elementFgLink,
                backgroundColor: .clear,
                hasShadow: false,
                shadowRadius: 2
            )
        case .inlineTextField:
            return CustomButtonConfig(
                font: .body,
                isBold: false,
                foregroundColor: Constants.Design.Colors.elementFgLowEmphasis,
                backgroundColor: .clear,
                hasShadow: false,
                shadowRadius: 2
            )
        }
    }
    
    var isInline: Bool {
        switch self {
        case .inline, .inlineLink, .inlineTextField:
            return true
        default:
            return false
        }
    }
}
