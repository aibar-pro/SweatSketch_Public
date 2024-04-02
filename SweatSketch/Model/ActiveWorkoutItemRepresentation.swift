//
//  ActiveWorkoutItemRepresentation.swift
//  SweatSketch
//
//  Created by aibaranchikov on 02.04.2024.
//

import Foundation

struct ActiveWorkoutItemRepresentation: Identifiable, Equatable {
    var id: UUID
    
    var name: String?
    var superSetName: String?
    var entityUUID: UUID?
    var type: ActiveWorkoutItemType?
    enum ActiveWorkoutItemType {
        case reps, timed, rest
    }
    var reps: Int16?
    var repsMax: Bool?
    var duration: Int32?
    
    init(name: String? = nil, superSetName: String? = nil, entityUUID: UUID? = nil, type: ActiveWorkoutItemType? = nil, reps: Int16? = nil, repsMax: Bool? = nil, duration: Int32? = nil) {
            self.id = UUID()
            self.entityUUID = entityUUID
            self.name = name
            self.superSetName = superSetName
            self.type = type
            self.reps = reps
            self.repsMax = repsMax
            self.duration = duration
        }
}

extension RestTimeEntity {
    func toActiveItemRepresentation() -> ActiveWorkoutItemRepresentation {
        return ActiveWorkoutItemRepresentation(name: self.name, entityUUID: self.uuid, type: .rest, duration: self.duration)
    }
}

extension ExerciseActionEntity {
    func restTimeToActiveItemRepresentation(name: String) -> ActiveWorkoutItemRepresentation {
        return ActiveWorkoutItemRepresentation(entityUUID: self.uuid, type: .rest, duration: self.duration)
    }
    func setNrepsActionToActiveItemRepresentation(name: String, superSetName: String? = nil) -> ActiveWorkoutItemRepresentation {
        if self.repsMax {
            return ActiveWorkoutItemRepresentation(name: name, superSetName: superSetName, entityUUID: self.uuid, type: .reps, repsMax: true)
        } else {
            return ActiveWorkoutItemRepresentation(name: name, superSetName: superSetName, entityUUID: self.uuid, type: .reps, reps: self.reps)
        }
    }
    func timedActionToActiveItemRepresentation(name: String, superSetName: String? = nil) -> ActiveWorkoutItemRepresentation {
        return ActiveWorkoutItemRepresentation(name: name, superSetName: superSetName, entityUUID: self.uuid, type: .timed, duration: self.duration)
    }
}
