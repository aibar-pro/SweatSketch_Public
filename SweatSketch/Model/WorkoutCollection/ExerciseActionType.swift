//
//  ExerciseActionType.swift
//  SweatSketch
//
//  Created by aibaranchikov on 21.06.2025.
//

import SwiftUICore

enum ExerciseActionType: Equatable {
    case reps(sets: Int, min: Int, max: Int?, isMax: Bool)
    case timed(sets: Int, min: Int, max: Int?, isMax: Bool)
    case distance(sets: Int, min: Double, max: Double?, unit: String, isMax: Bool)
    case rest(duration: Int)
    
    func description(includeSets: Bool = false) -> String {
        let maxLabel: LocalizedStringKey = "app.max.value.label"
        let timeUnitLabel: String = TimeUnit.second.localizedShortDescription.stringValue()
        
        switch self {
        case .reps(let sets, let min, let max, let isMax):
            if isMax {
                return includeSets
                    ? maxLabel.stringValue() + " x\(sets)"
                    : maxLabel.stringValue()
            } else {
                let repPart = rangeString(min, max)
                return includeSets 
                    ? repPart + " x\(sets)"
                    : repPart
            }
        case .timed(let sets, let min, let max, let isMax):
            if isMax {
                return includeSets
                    ? maxLabel.stringValue() + " x\(sets)"
                    : maxLabel.stringValue()
            } else {
                let timePart = rangeString(min, max, unit: timeUnitLabel)
                return includeSets
                    ? timePart + " x\(sets)"
                    : timePart
            }
        case .distance(let sets, let min, let max, let unit, let isMax):
            if isMax {
                return includeSets
                    ? maxLabel.stringValue() + " x\(sets)"
                    : maxLabel.stringValue()
            } else {
                let minStr = min.formatted(precision: 2)
                let maxStr = max?.formatted(precision: 2)
                let unitLabel = HeightUnit(rawValue: unit)?.localizedShortDescription.stringValue() ?? unit
                let distPart = rangeString(minStr, maxStr, unit: unitLabel)
                return includeSets
                    ? distPart + " x\(sets)"
                    : distPart
            }
        case .rest(let duration):
            return "\(duration)" + timeUnitLabel
        }
    }
    
    private func rangeString<T: CustomStringConvertible & Equatable>(
        _ min: T,
        _ max: T?,
        unit: String = ""
    ) -> String {
        if let max, max != min {
            return "\(min)-\(max) \(unit)"
        } else {
            return "\(min) \(unit)"
        }
    }
}

extension ExerciseActionType {
    var setsCount: Int {
        switch self {
        case .reps(let s, _, _, _),
                .timed(let s, _, _, _),
                .distance(let s, _, _, _, _):
            return max(1, s)
        case .rest:
            return 1
        }
    }
    
    var iconName: String {
        switch self {
        case .rest: return "pause.circle"
        case .reps: return "123.rectangle"
        case .timed: return "gauge"
        case .distance: return "map"
        }
    }
    
    var primaryLabel: LocalizedStringKey {
        .init(description(includeSets: false))
    }
    
    var setsSuffix: LocalizedStringKey? {
        let n = setsCount
        return n > 1 ? .init("× \(n)") : nil
    }
}

extension ExerciseActionType {
    var kind: ActionKind {
        switch self {
        case .reps:      return .reps
        case .timed:     return .timed
        case .distance:  return .distance
        case .rest:      return .rest
        }
    }
}
