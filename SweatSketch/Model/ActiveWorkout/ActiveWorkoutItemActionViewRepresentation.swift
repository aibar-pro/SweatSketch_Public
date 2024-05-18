//
//  ActiveWorkoutItemActionViewRepresentation.swift
//  SweatSketch
//
//  Created by aibaranchikov on 14.04.2024.
//

import Foundation

class ActiveWorkoutItemActionViewRepresentation: Identifiable, Equatable, ObservableObject {
    static func == (lhs: ActiveWorkoutItemActionViewRepresentation, rhs: ActiveWorkoutItemActionViewRepresentation) -> Bool {
        return 
            lhs.id == rhs.id &&
            lhs.entityUUID == rhs.entityUUID &&
            lhs.title == rhs.title &&
            lhs.type == rhs.type &&
            lhs.duration == rhs.duration &&
            lhs.reps == rhs.reps &&
            lhs.repsMax == rhs.repsMax
    }
    
    let id: UUID
    let entityUUID: UUID
    let title: String
    let type: ActiveItemActionType
    enum ActiveItemActionType {
        case timed, setsNreps, rest
    }
    var duration: Int32?
    var reps: Int16?
    var repsMax: Bool?
    
    private let workoutDataManager = WorkoutDataManager()
    
    init?(entityUUID: UUID, title: String? = nil, type: ActiveItemActionType, duration: Int32? = nil, reps: Int16? = nil, repsMax: Bool? = false) {
        self.id = UUID()
        self.entityUUID = entityUUID
        self.type = type
        
        switch type {
        case .rest:
            self.title = Constants.Placeholders.restPeriodLabel
            guard let actionDuration = duration else { return nil }
            self.duration = actionDuration
        case .timed:
            self.title = title ?? Constants.Placeholders.noActionName
            guard let actionDuration = duration else { return nil }
            self.duration = actionDuration
        case .setsNreps:
            self.title = title ?? Constants.Placeholders.noActionName
            if let maximumRepetitions = repsMax, maximumRepetitions {
                self.repsMax = true
            } else {
                guard let actionReps = reps else { return nil }
                self.reps = actionReps
            }
        }
    }
}

extension ExerciseActionEntity {
    func toActiveWorkoutItemActionViewRepresentation(exerciseName: String?) -> ActiveWorkoutItemActionViewRepresentation? {
        guard let uuid = self.uuid else { return nil }
        
        if self.isRestTime {
            if self.duration >= 0 {
                return ActiveWorkoutItemActionViewRepresentation(entityUUID: uuid, type: .rest, duration: self.duration)
            } else { return nil }
        } else {
            switch ExerciseActionType.from(rawValue: self.type) {
            case .setsNreps:
                return ActiveWorkoutItemActionViewRepresentation(entityUUID: uuid, title: exerciseName ?? self.name, type: .setsNreps, reps: self.reps, repsMax: self.repsMax)
            case .timed:
                return ActiveWorkoutItemActionViewRepresentation(entityUUID: uuid, title: exerciseName ?? self.name, type: .timed, duration: self.duration)
            default:
                return nil
            }
        }
        
    }
}

extension ActiveWorkoutActionAttributes.ActiveWorkoutActionStatus {
    init(action: ActiveWorkoutItemActionViewRepresentation, totalActions: Int, currentAction: Int) {
        self.actionID = action.id
        self.title = action.title
        self.repsCount = action.reps
        self.repsMax = action.repsMax
        if let duration = action.duration { self.duration = Int(duration) }
        self.totalActions = totalActions
        self.currentAction = currentAction
    }
}
