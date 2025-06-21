//
//  ExerciseActionType.swift
//  SweatSketch
//
//  Created by aibaranchikov on 21.06.2025.
//


enum ExerciseActionType: Equatable {
    case reps(sets: Int, min: Int, max: Int?, isMax: Bool)
    case timed(sets: Int, min: Int, max: Int?, isMax: Bool)
    case distance(sets: Int, min: Double, max: Double?, unit: String, isMax: Bool)
    case rest(duration: Int)
    
    var description: String {
        switch self {
        case .reps(let sets, let min, let max, let isMax):
            if isMax {
                return "MAX x \(sets)"
            } else {
                let repPart: String
                if let max, max != min {
                    repPart = "\(min)-\(max)"
                } else {
                    repPart = "\(min)"
                }
                return "\(repPart) x \(sets)"
            }
        case .timed(let sets, let min, let max, let isMax):
            if isMax {
                return "MAX x \(sets)"
            } else {
                let timePart: String
                if let max, max != min {
                    timePart = "\(min)-\(max)"
                } else {
                    timePart = "\(min)"
                }
                return "\(timePart)s x \(sets)"
            }
        case .distance(let sets, let min, let max, let unit, let isMax):
            if isMax {
                return "MAX x \(sets)"
            } else {
                let minStr = min.formatted(precision: 2)
                let part: String
                if let max, max != min {
                    part = "\(minStr)-\(max.formatted(precision: 2))"
                } else {
                    part = minStr
                }
                return "\(part)\(unit) x \(sets)"
            }
            
        case .rest(let duration):
            return "\(duration)s"
        }
    }
}
