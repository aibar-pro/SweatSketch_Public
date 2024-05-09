//
//  WorkoutCatalogWorkoutViewRepresentation.swift
//  SweatSketch
//
//  Created by aibaranchikov on 06.04.2024.
//

import Foundation

class WorkoutCatalogWorkoutViewRepresentation: Identifiable, Equatable, ObservableObject {
    static func == (lhs: WorkoutCatalogWorkoutViewRepresentation, rhs: WorkoutCatalogWorkoutViewRepresentation) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
    
    let id: UUID
    var name: String
    
    init?(workout: WorkoutEntity) {
        guard let id = workout.uuid else { return nil }
        self.id = id
        self.name = workout.name ?? Constants.Placeholders.noWorkoutName
    }
}

extension WorkoutEntity {
    func toWorkoutCollectionWorkoutRepresentation() -> WorkoutCatalogWorkoutViewRepresentation? {
        return WorkoutCatalogWorkoutViewRepresentation(workout: self)
    }
}
