//
//  ActiveWorkoutItemRepresentation.swift
//  SweatSketch
//
//  Created by aibaranchikov on 02.04.2024.
//

import Foundation

struct ActiveWorkoutItemRepresentation: Identifiable, Equatable {
    var id: UUID
    var name: String
    var type: ActiveWorkoutItemType?
    enum ActiveWorkoutItemType {
        case exercise, rest
    }
    var status: ActiveItemStatus?
    enum ActiveItemStatus {
        case new, inProgress, finished
    }
    var restTimeDuration: Int32?
}

extension RestTimeEntity {
    func toActiveItemRepresentation() throws -> ActiveWorkoutItemRepresentation {
        guard let uuid = self.uuid else {
            throw ActiveWorkoutError.invalidItemUUID
        }
        return ActiveWorkoutItemRepresentation(id: uuid, name: Constants.Placeholders.restPeriodLabel, type: .rest, status: .new, restTimeDuration: self.duration)
    }
}

extension ExerciseEntity {
    func toActiveWorkoutItemRepresentation() throws -> ActiveWorkoutItemRepresentation {
        guard let uuid = self.uuid else {
            throw ActiveWorkoutError.invalidItemUUID
        }
        return ActiveWorkoutItemRepresentation(id: uuid, name: self.name ?? Constants.Placeholders.noExerciseName, type: .exercise, status: .new)
    }
}
