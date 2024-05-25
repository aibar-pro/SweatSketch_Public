//
//  ExerciseType.swift
//  SweatSketch
//
//  Created by aibaranchikov on 19.03.2024.
//

enum ExerciseType: String {
    case setsNreps, timed, mixed
    case unknown
    
    static let exerciseTypes: [ExerciseType] = [.setsNreps, .timed, .mixed]
    
    var iconName: String {
        switch self {
        case .setsNreps: return "123.rectangle.fill"//"target"//"flame.fill" //arrow.clockwise.circle.fill
        case .timed: return "gauge.with.needle.fill"//"clock.fill" //gauge.with.needle
        case .mixed: return "flame.fill"//"shuffle" //square.stack.3d.up.fill
        case .unknown: return "questionmark.circle"
        }
    }
    
    var screenTitle: String {
        switch self {
        case .setsNreps: return Constants.Placeholders.ExerciseTypes.setsNreps
        case .timed: return Constants.Placeholders.ExerciseTypes.timed
        case .mixed: return Constants.Placeholders.ExerciseTypes.mixed
        case .unknown: return Constants.Placeholders.ExerciseTypes.unknown
        }
    }
}

extension ExerciseType {
    static func from(rawValue: String?) -> ExerciseType {
        guard let rawValue = rawValue, let type = ExerciseType(rawValue: rawValue) else {
            return .unknown
        }
        return type
    }
}
