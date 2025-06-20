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
    
    var description: String {
        switch self {
        case .reps(let sets, let min, let max, let isMax):
            if isMax {
                return "MAX x \(sets)"
            } else {
                let repPart: String
                if let max, max != min {
                    repPart = "\(min)-\(max)"
                } else {
                    repPart = "\(min)"
                }
                return "\(repPart) x \(sets)"
            }
        case .timed(let sets, let min, let max, let isMax):
            if isMax {
                return "MAX x \(sets)"
            } else {
                let timePart: String
                if let max, max != min {
                    timePart = "\(min)-\(max)"
                } else {
                    timePart = "\(min)"
                }
                return "\(timePart)s x \(sets)"
            }
        case .distance(let sets, let min, let max, let unit, let isMax):
            if isMax {
                return "MAX x \(sets)"
            } else {
                func format(_ v: Double) -> String {
                    return v.truncatingRemainder(dividingBy: 1) == 0
                    ? String(Int(v))
                    : String(v)
                }
                let minStr = format(min)
                let part: String
                if let max, max != min {
                    part = "\(minStr)-\(format(max))"
                } else {
                    part = minStr
                }
                return "\(part)\(unit) x \(sets)"
            }
            
        case .rest(let duration):
            return "Rest: \(duration)s"
        }
    }
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
        
        let title: String = {
            guard let actionName = self.name,
                    !actionName.isEmpty
            else { return exerciseName }
            
            return actionName == exerciseName ? exerciseName : actionName
        }() ?? ""
        
        switch self {
        case let rest as RestActionEntity:
            return ActionViewRepresentation(
                entityUUID: uuid,
                title: Constants.Placeholders.restPeriodLabel,
                type: .rest(
                    duration: rest.duration.int
                )
            )
        case let t as TimedActionEntity:
            return ActionViewRepresentation(
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
            return ActionViewRepresentation(
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
            return ActionViewRepresentation(
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

extension ActiveWorkoutActionAttributes.ActiveWorkoutActionStatus {
    init(action: ActionViewRepresentation, totalActions: Int, currentAction: Int) {
        self.actionID = action.id
        self.title = action.title
        self.totalActions = totalActions
        self.currentAction = currentAction
    }
}
