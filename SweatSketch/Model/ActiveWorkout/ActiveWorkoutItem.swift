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
    
    var status: ActiveItemStatus?
    enum ActiveItemStatus {
        case new, inProgress, finished
    }
    var actions = [ActionRepresentation]()
    
    private let exerciseDataManager = ExerciseDataManager()
    

    init?(
        entityUUID: UUID,
        title: String,
        restTime: Int,
        in context: NSManagedObjectContext
    ) {
        self.id = UUID()
        self.entityUUID = entityUUID
        self.title = title
        
        guard let exercise = exerciseDataManager.fetchExercise(by: entityUUID, in: context) else { return nil }
        self.actions = fetchActions(
            exercise: exercise,
            restTime: restTime,
            in: context
        )

        self.status = .new
    }
    
    init?(restTime: Int) {
        self.id = UUID()
        self.entityUUID = UUID()
        self.title = Constants.Placeholders.restPeriodLabel
        
        let restTimeAction = ActionRepresentation(
            entityUUID: self.entityUUID,
            title: self.title,
            type: .rest(duration: restTime)
        )
        self.actions = [restTimeAction]
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
        restTime: Int,
        in context: NSManagedObjectContext
    ) -> [ActionRepresentation] {
        let fetchedActions = exerciseDataManager.fetchActions(for: exercise, in: context)
        
        var actions = [ActionRepresentation]()
        
        for superSetIndex in 0..<exercise.superSets {
            if superSetIndex > 0 {
                appendRestTime(to: &actions, duration: restTime)
            }
            for (actionIndex, action) in fetchedActions.enumerated() {
                if actionIndex > 0 {
                    appendRestTime(to: &actions, duration: restTime)
                }
                
                for setsIndex in 0..<action.sets {
                    if let actionRepresentation = action.toActionViewRepresentation(exerciseName: exercise.name) {
                        if setsIndex > 0 {
                            appendRestTime(to: &actions, duration: restTime)
                        }
                        actions.append(actionRepresentation)
                    }
                }
            }
        }
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

extension ExerciseEntity {
    func toActiveWorkoutItem(defaultRest: Int) -> ActiveWorkoutItem? {
        guard let uuid = self.uuid else { return nil }
        guard let context = self.managedObjectContext else { return nil }
        return ActiveWorkoutItem(
            entityUUID: uuid,
            title: self.name ?? Constants.Placeholders.noExerciseName,
            restTime: self.intraRest.intValue ?? defaultRest,
            in: context
        )
    }
}
