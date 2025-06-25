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
    let kind: ItemKind
    enum ItemKind {
        case exercise(defaultRestDuration: Int), rest(duration: Int)
    }
    var status: ActiveItemStatus?
    enum ActiveItemStatus {
        case new, inProgress, finished
    }
    var actions = [ActionRepresentation]()
    
    private let exerciseDataManager = ExerciseDataManager()
    
    init?(
        entityUUID: UUID,
        title: String,
        kind: ItemKind,
        in context: NSManagedObjectContext
    ) {
        self.id = UUID()
        self.entityUUID = entityUUID
        self.kind =         kind
        self.title = title
        
        switch         kind {
        case .exercise(let restTime):
            guard let exercise = exerciseDataManager.fetchExercise(by: entityUUID, in: context) else { return nil }
            self.actions = fetchActions(
                exercise: exercise,
                defaultRestDuration: restTime,
                in: context
            )
        case .rest(let duration):
            let restTimeAction = ActionRepresentation(
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
        defaultRestDuration: Int,
        in context: NSManagedObjectContext
    ) -> [ActionRepresentation] {
        let fetchedActions = exerciseDataManager.fetchActions(for: exercise, in: context)
        
        let restTimeDuration: Int = { 1
//            if fetchedActions.contains(where: { $0.type == .rest }) {
//                
//            }
        }()
        
        var actions = [ActionRepresentation]()
        
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
    
    private func appendRestTime(to actions: inout [ActionRepresentation], duration: Int) {
        actions.append(
            ActionRepresentation(
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
            kind: .rest(duration: self.duration.int),
            in: context
        )
    }
}

extension ExerciseEntity {
    func toActiveWorkoutItem(defaultRestDuration: Int) -> ActiveWorkoutItem? {
        guard let uuid = self.uuid else { return nil }
        guard let context = self.managedObjectContext else { return nil }
        return ActiveWorkoutItem(
            entityUUID: uuid,
            title: self.name ?? Constants.Placeholders.noExerciseName,
            kind: .exercise(defaultRestDuration: defaultRestDuration),
            in: context
        )
    }
}
