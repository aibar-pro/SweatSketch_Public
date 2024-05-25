//
//  ExerciseActionType.swift
//  SweatSketch
//
//  Created by aibaranchikov on 19.03.2024.
//

enum ExerciseActionType: String, CaseIterable {
    case setsNreps, timed
    case unknown
    
    static let exerciseActionTypes: [ExerciseActionType] = [.setsNreps, .timed]
    
    var iconName: String {
        switch self {
        case .setsNreps: return "123.rectangle.fill"
        case .timed: return "gauge.with.needle.fill"
        case .unknown: return "questionmark.circle"
        }
    }
    
    var screenTitle: String {
        switch self {
        case .setsNreps: return Constants.Placeholders.ExerciseActionTypes.setsNreps
        case .timed: return Constants.Placeholders.ExerciseActionTypes.timed
        case .unknown: return Constants.Placeholders.ExerciseActionTypes.unknown
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
