//
//  ExerciseType.swift
//  SweatSketch
//
//  Created by aibaranchikov on 19.03.2024.
//

import Foundation

//Consider deletion

enum ExerciseType: String {
    case setsNreps, timed, mixed
    case unknown
    
    var iconName: String {
        switch self {
        case .setsNreps: return "123.rectangle.fill"//"target"//"flame.fill" //arrow.clockwise.circle.fill
        case .timed: return "gauge.with.needle.fill"//"clock.fill" //gauge.with.needle
        case .mixed: return "flame.fill"//"shuffle" //square.stack.3d.up.fill
        case .unknown: return "questionmark.circle"
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
