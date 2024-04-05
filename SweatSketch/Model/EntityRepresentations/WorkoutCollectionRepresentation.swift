//
//  WorkoutCollectionRepresentation.swift
//  SweatSketch
//
//  Created by aibaranchikov on 06.04.2024.
//

import Foundation

struct WorkoutCollectionRepresentation: Identifiable {
    let id: UUID
    var name: String
    var subCollections: [WorkoutCollectionRepresentation] = []
    var workouts: [WorkoutEntity] = []
}
