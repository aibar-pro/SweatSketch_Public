//
//  ActionViewRepresentation.swift
//  SweatSketch
//
//  Created by aibaranchikov on 10.04.2024.
//

import Foundation

enum ExerciseActionType: Equatable {
    case reps(sets: Int, min: Int, max: Int?, isMax: Bool)
    case timed(sets: Int, min: Int, max: Int?, isMax: Bool)
    case distance(sets: Int, min: Double, max: Double?, unit: String, isMax: Bool)
    case rest(duration: Int)
}

class ActionViewRepresentation: Identifiable {
    let id: UUID
    let entityUUID: UUID
    let title: String
    let type: ExerciseActionType
    
    @Published var progress: Double = 0.0

    private let workoutDataManager = WorkoutDataManager()
    
    init(
        entityUUID: UUID,
        title: String,
        type: ExerciseActionType,
        progress: Double = 0.0
    ) {
        self.id = UUID()
        self.entityUUID = entityUUID
        self.title = title
        self.type = type
        self.progress = min(max(progress, 0.0), 1.0)
    }
}

extension ActionViewRepresentation: Equatable {
    static func == (lhs: ActionViewRepresentation, rhs: ActionViewRepresentation) -> Bool {
        return lhs.entityUUID == rhs.entityUUID
            && lhs.title == rhs.title
            && lhs.type == rhs.type
            && lhs.progress == rhs.progress
    }
}

extension ExerciseActionEntity {
    func toActionViewRepresentation(exerciseName: String? = nil) -> ActionViewRepresentation? {
        guard let uuid = uuid else { return nil }
        let title = exerciseName ?? self.exercise?.name ?? ""
        switch self {
        case let rest as RestActionEntity:
            let duration = Int(rest.duration)
            return ActionViewRepresentation(
                entityUUID: uuid,
                title: Constants.Placeholders.restPeriodLabel,
                type: .rest(duration: duration)
            )
        case let t as TimedActionEntity:
            let minSec = Int(t.secondsMin)
            let maxSec = Int(t.secondsMax)
            return ActionViewRepresentation(
                entityUUID: uuid,
                title: title,
                type: .timed(
                    sets: Int(t.sets),
                    min: minSec,
                    max: maxSec,
                    isMax: t.isMax
                )
            )
        case let r as RepsActionEntity:
            let minReps = Int(r.repsMin)
//            let maxReps = r.repsMax.map(Int.init)
            let maxReps = Int(r.repsMax)
            return ActionViewRepresentation(
                entityUUID: uuid,
                title: title,
                type: .reps(
                    sets: Int(r.sets),
                    min: minReps,
                    max: maxReps,
                    isMax: r.isMax
                )
            )
//        case let d as DistanceActionEntity:
//            let minDist = d.distanceMin
//            let maxDist = d.distanceMax
//            let unit = d.distanceUnit
//            return ActiveWorkoutItem(
//                entityUUID: uuid,
//                title: title,
//                type: .distance(min: minDist, max: maxDist, unit: unit, isMax: false)
//            )
        default:
            return nil
        }
    }
}

extension ActiveWorkoutActionAttributes.ActiveWorkoutActionStatus {
    init(action: ActionViewRepresentation, totalActions: Int, currentAction: Int) {
        self.actionID = action.id
        self.title = action.title
        self.totalActions = totalActions
        self.currentAction = currentAction
    }
}
