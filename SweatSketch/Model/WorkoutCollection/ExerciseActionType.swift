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
                let repPart = min.rangeString(to: max)
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
                let timePart = min.rangeString(to: max, unit: timeUnitLabel)
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
                let unitLabel = LengthUnit(rawValue: unit)?.localizedName ?? unit
                let distPart = minStr.rangeString(to: maxStr, unit: unitLabel)
                return includeSets
                    ? distPart + " x\(sets)"
                    : distPart
            }
        case .rest(let duration):
            return "\(duration)" + timeUnitLabel
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
