//
//  ExerciseActionType.swift
//  SweatSketch
//
//  Created by aibaranchikov on 19.03.2024.
//

enum ExerciseActionType: String, CaseIterable {
    case setsNreps, timed
    case unknown
    
    var iconName: String {
        switch self {
        case .setsNreps: return "123.rectangle.fill"
        case .timed: return "gauge.with.needle.fill"
        case .unknown: return "questionmark.circle"
        }
    }
}

extension ExerciseActionType {
    static func from(rawValue: String?) -> ExerciseActionType {
        guard let rawValue = rawValue, let type = ExerciseActionType(rawValue: rawValue) else {
            return .unknown
        }
        return type
    }
}
