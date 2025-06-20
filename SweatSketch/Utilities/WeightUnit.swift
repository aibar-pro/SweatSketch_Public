//
//  WeightUnit.swift
//  SweatSketch
//
//  Created by aibaranchikov on 18.06.2025.
//

import SwiftUICore

enum WeightUnit: String, CaseIterable {
    case kilograms
    case pounds
    
    var localizedShortDescription: LocalizedStringKey {
        switch self {
        case .kilograms:
            return "app.weight.unit.kilograms.short"
        case .pounds:
            return "app.weight.unit.pounds.short"
        }
    }
}
