//
//  WeightType.swift
//  SweatSketch
//
//  Created by aibaranchikov on 19.03.2024.
//

enum WeightType: String {
    case dumbbell, barbell, machine, body
    case unknown
    
//    var iconName: String {
//        switch self {
//        case .dumbbell: return "dumbbell.fill"
//        case .barbell: return "figure.strengthtraining.traditional"
//        case .machine: return "square.stack.3d.up.fill"
//        case .body: return "figure.mixed.cardio"
//        case .unknown: return "questionmark.circle"
//        }
//    }
}

extension WeightType {
    static func from(rawValue: String?) -> WeightType {
        guard let rawValue = rawValue, let type = WeightType(rawValue: rawValue) else {
            return .unknown
        }
        return type
    }
}
