//
//  ActiveWorkoutItem.swift
//  SweatSketch
//
//  Created by aibaranchikov on 14.04.2024.
//

import CoreData

class ActiveWorkoutItem: Identifiable, ObservableObject {
    let id: UUID
    let entityUUID: UUID
    let title: String
    let type: ActiveWorkoutItemType
    enum ActiveWorkoutItemType {
        case exercise(defaultWorkoutRestTimeDuration: Int), rest(duration: Int)
    }
    var status: ActiveItemStatus?
    enum ActiveItemStatus {
        case new, inProgress, finished
    }
    var actions = [ActionViewRepresentation]()
    
    private let exerciseDataManager = ExerciseDataManager()
    
    // I've decided yet how to pass default workout rest time, but I need it for unwrapping workout
    init?(
        entityUUID: UUID,
        title: String,
        type: ActiveWorkoutItemType,
        in context: NSManagedObjectContext
    ) {
        self.id = UUID()
        self.entityUUID = entityUUID
        self.type = type
        self.title = title
        
        switch type {
        case .exercise(let restTime):
            guard let exercise = exerciseDataManager.fetchExercise(by: entityUUID, in: context) else { return nil }
            self.actions = fetchActions(
                exercise: exercise,
                defaultWorkoutRestTimeDuration: restTime,
                in: context
            )
        case .rest(let duration):
            let restTimeAction = ActionViewRepresentation(
                entityUUID: entityUUID,
                title: self.title,
                type: .rest(duration: duration),
                progress: 0.0
            )
            self.actions = [restTimeAction]
        }
        self.status = .new
    }
    
    func countNonRestActions() -> Int {
        return actions.count {
            if case .rest = $0.type {
                return false
            }
            return true
        }
    }
    
    private func fetchActions(
        exercise: ExerciseEntity,
        defaultWorkoutRestTimeDuration: Int,
        in context: NSManagedObjectContext
    ) -> [ActionViewRepresentation] {
        let fetchedActions = exerciseDataManager.fetchActions(for: exercise, in: context)
        
        let restTimeDuration: Int = { 1
//            if fetchedActions.contains(where: { $0.type == .rest }) {
//                
//            }
        }()
        
        var actions = [ActionViewRepresentation]()
        
        var supersetCount: Int
        var isSuperset = false
//        
//        switch ExerciseType.from(rawValue: exercise.type) {
//        case .mixed:
//            supersetCount = Int(exercise.superSets)
//            isSuperset = true
//        default:
//            supersetCount = 1
//        }
//        
//        var actionRepetitionsCount: Int
//        
//        for supersetIndex in 0..<supersetCount {
//            if supersetIndex > 0 {
//                appendRestTime(to: &actions, duration: restTimeDuration)
//            }
//            for (actionIndex, action) in fetchedActions.enumerated() {
//                if actionIndex > 0 {
//                    appendRestTime(to: &actions, duration: restTimeDuration)
//                }
//                
//                if ExerciseType.from(rawValue: exercise.type) == .setsNreps {
//                    actionRepetitionsCount = Int(action.sets)
//                } else {
//                    actionRepetitionsCount = 1
//                }
//                
//                for setsIndex in 0..<actionRepetitionsCount {
//                    if let actionRepresentation = action.toExerciseActionModel(exerciseName: !isSuperset ? exercise.name : nil) {
//                        if setsIndex > 0 {
//                            appendRestTime(to: &actions, duration: restTimeDuration)
//                        }
//                        actions.append(actionRepresentation)
//                    }
//                }
//            }
//        }
        return actions
    }
    
    private func appendRestTime(to actions: inout [ActionViewRepresentation], duration: Int) {
        actions.append(
            ActionViewRepresentation(
                entityUUID: UUID(),
                title: Constants.Placeholders.restPeriodLabel,
                type: .rest(duration: duration)
            )
        )
    }
}

extension ActiveWorkoutItem: Equatable {
    static func == (lhs: ActiveWorkoutItem, rhs: ActiveWorkoutItem) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.entityUUID == rhs.entityUUID &&
            lhs.title == rhs.title &&
            lhs.status == rhs.status &&
            lhs.actions == rhs.actions
    }
}

extension RestTimeEntity {
    func toActiveWorkoutItem() -> ActiveWorkoutItem? {
        guard let uuid = self.uuid else { return nil }
        guard let context = self.managedObjectContext else { return nil }
        return ActiveWorkoutItem(
            entityUUID: uuid,
            title: Constants.Placeholders.restPeriodLabel,
            type: .rest(duration: self.duration.int),
            in: context
        )
    }
}

extension ExerciseEntity {
    func toActiveWorkoutItem(defaultWorkoutRestTimeDuration: Int) -> ActiveWorkoutItem? {
        guard let uuid = self.uuid else { return nil }
        guard let context = self.managedObjectContext else { return nil }
        return ActiveWorkoutItem(
            entityUUID: uuid,
            title: self.name ?? Constants.Placeholders.noExerciseName,
            type: .exercise(defaultWorkoutRestTimeDuration: defaultWorkoutRestTimeDuration),
            in: context
        )
    }
}
