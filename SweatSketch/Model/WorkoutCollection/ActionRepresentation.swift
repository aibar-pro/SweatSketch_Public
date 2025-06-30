//
//  ActionRepresentation.swift
//  SweatSketch
//
//  Created by aibaranchikov on 10.04.2024.
//

import SwiftUICore

enum ActionKind: Equatable, CaseIterable {
    case reps, timed, distance, rest
    
    var localizedTitle: LocalizedStringKey {
        switch self {
        case .reps: return "action.kind.reps"
        case .timed: return "action.kind.timed"
        case .distance: return "action.kind.distance"
        case .rest: return "action.kind.rest"
        }
    }
    
    var isNonRest: Bool {
        switch self {
        case .rest: return false
        default: return true
        }
    }
}

class ActionRepresentation: Identifiable, ObservableObject {
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

extension ActionRepresentation: Equatable {
    static func == (lhs: ActionRepresentation, rhs: ActionRepresentation) -> Bool {
        return lhs.entityUUID == rhs.entityUUID
            && lhs.title == rhs.title
            && lhs.type == rhs.type
            && lhs.progress == rhs.progress
    }
}

extension ExerciseActionEntity {
    func toActionViewRepresentation(exerciseName: String? = nil) -> ActionRepresentation? {
        guard let uuid = uuid else { return nil }
        
        let title: String = {
            guard let actionName = self.name,
                    !actionName.isEmpty
            else { return exerciseName }
            
            return actionName == exerciseName ? exerciseName : actionName
        }() ?? ""
        
        switch self {
        case let rest as RestActionEntity:
            return ActionRepresentation(
                entityUUID: uuid,
                title: Constants.Placeholders.restPeriodLabel,
                type: .rest(
                    duration: rest.duration.int
                )
            )
        case let t as TimedActionEntity:
            return ActionRepresentation(
                entityUUID: uuid,
                title: title,
                type: .timed(
                    sets: t.sets.int,
                    min: t.secondsMin.int,
                    max: t.secondsMax?.intValue,
                    isMax: t.isMax
                )
            )
        case let r as RepsActionEntity:
            return ActionRepresentation(
                entityUUID: uuid,
                title: title,
                type: .reps(
                    sets: r.sets.int,
                    min: r.repsMin.int,
                    max: r.repsMax?.intValue,
                    isMax: r.isMax
                )
            )
        case let d as DistanceActionEntity:
            return ActionRepresentation(
                entityUUID: uuid,
                title: title,
                type: .distance(
                    sets: d.sets.int,
                    min: d.distanceMin,
                    max: d.distanceMax?.doubleValue,
                    unit: d.unit ?? "m",
                    isMax: d.isMax
                )
            )
        default:
            return nil
        }
    }
}

extension ActiveWorkoutActivityState {
    init(action: ActionRepresentation, progress: Double, stepIndex: Int, totalSteps: Int) {
        self.actionID = action.id
        self.title = action.title
        self.quantity = action.type.description(includeSets: false)
        self.progress = progress
        self.isRest = {
            if case .rest = action.type {
                return true
            }
            return false
        }()
        self.stepIndex = stepIndex
        self.totalSteps = totalSteps
    }
}
