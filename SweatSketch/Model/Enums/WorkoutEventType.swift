//
//  WorkoutEvent.swift
//  SweatSketch
//
//  Created by aibaranchikov on 02.04.2024.
//

import Foundation

enum WorkoutEventType {
    case started(UUID)
    case finished
    case enterCollections
    case openCollection(UUID)
}
