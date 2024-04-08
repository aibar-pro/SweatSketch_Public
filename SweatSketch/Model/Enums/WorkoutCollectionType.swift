//
//  WorkoutCollectionType.swift
//  SweatSketch
//
//  Created by aibaranchikov on 07.04.2024.
//

enum WorkoutCollectionType: String {
    case defaultCollection
    case imported
    case user
    case unknown
}

extension WorkoutCollectionType {
    static func from(rawValue: String?) -> WorkoutCollectionType {
        guard let rawValue = rawValue, let type = WorkoutCollectionType(rawValue: rawValue) else {
            return .unknown
        }
        return type
    }
}
