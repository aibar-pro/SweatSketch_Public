//
// LengthUnit.swift
// SweatSketch
//
// Created by aibaranchikov on 18.06.2025.
//

import Foundation
import SwiftUI

enum LengthUnit: String, CaseIterable, Codable, Hashable, Identifiable {
    case kilometers
    case meters
    case centimeters
    
    case inches
    case miles
    case feet
    
    var id: Self { self }
    
    var isImperial: Bool {
        [.miles, .inches, .feet].contains(self)
    }
    
    var isMetric: Bool {
        !isImperial
    }
    
    var unitLength: UnitLength {
        switch self {
        case .centimeters: return .centimeters
        case .meters: return .meters
        case .kilometers: return .kilometers
        case .inches: return .inches
        case .feet: return .feet
        case .miles: return .miles
        }
    }
    
    var symbol: String {
        unitLength.symbol
    }
    
    var localizedName: String {
        let fmt = MeasurementFormatter()
        fmt.unitStyle = .medium
        fmt.locale = .current
        return fmt
            .string(from: unitLength)
            .replacingOccurrences(of: "1 ", with: "")
    }
}

extension Double {
    func converted(
        from source: LengthUnit,
        to target: LengthUnit
    ) -> Double {
        let measurement = Measurement(value: self, unit: source.unitLength)
        return measurement.converted(to: target.unitLength).value
    }
}

extension Measurement where UnitType == UnitLength {
    func formatted(precision: Int = 2) -> String {
        let fmt = MeasurementFormatter()
        fmt.unitStyle = .short
        fmt.numberFormatter.maximumFractionDigits = precision
        return fmt.string(from: self)
    }
    
    func converted(to target: LengthUnit) -> Measurement<UnitLength> {
        converted(to: target.unitLength)
    }
}
