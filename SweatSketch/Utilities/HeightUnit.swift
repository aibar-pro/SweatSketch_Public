//
//  HeightUnit.swift
//  SweatSketch
//
//  Created by aibaranchikov on 18.06.2025.
//

import SwiftUICore

enum HeightUnit: String, CaseIterable {
    case centimeters
    case feetAndInches
    
    var localizedShortDescription: LocalizedStringKey {
        switch self {
        case .centimeters:
            return "app.height.unit.centimeters.short"
        case .feetAndInches:
            return "app.height.unit.feetAndInches.short"
        }
    }
}
