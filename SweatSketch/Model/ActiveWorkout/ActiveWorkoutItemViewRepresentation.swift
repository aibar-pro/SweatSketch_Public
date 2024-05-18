//
//  ActiveWorkoutItemViewRepresentation.swift
//  SweatSketch
//
//  Created by aibaranchikov on 14.04.2024.
//

import CoreData

class ActiveWorkoutItemViewRepresentation: Identifiable, Equatable, ObservableObject {
    static func == (lhs: ActiveWorkoutItemViewRepresentation, rhs: ActiveWorkoutItemViewRepresentation) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.entityUUID == rhs.entityUUID &&
            lhs.title == rhs.title &&
            lhs.type == rhs.type &&
            lhs.status == rhs.status &&
            lhs.restTimeDuration == rhs.restTimeDuration &&
            lhs.actions == rhs.actions
    }
    
    let id: UUID
    let entityUUID: UUID
    let title: String
    let type: ActiveWorkoutItemType
    enum ActiveWorkoutItemType {
        case exercise, rest
    }
    var status: ActiveItemStatus?
    enum ActiveItemStatus {
        case new, inProgress, finished
    }
    var restTimeDuration: Int32?
    var actions = [ActiveWorkoutItemActionViewRepresentation]()
    
    private let exerciseDataManager = ExerciseDataManager()
    
    init?(entityUUID: UUID, title: String? = nil, type: ActiveWorkoutItemType, restTimeDuration: Int32? = nil, in context: NSManagedObjectContext) {
        self.id = UUID()
        self.entityUUID = entityUUID
        
        self.type = type
        
        switch type {
        case .exercise:
            guard let exercise = exerciseDataManager.fetchExercise(by: entityUUID, in: context) else { return nil }
            self.title = title ?? Constants.Placeholders.noExerciseName
            self.actions = fetchActions(exercise: exercise, in: context)
        case .rest:
            self.title = Constants.Placeholders.restPeriodLabel
            self.restTimeDuration = restTimeDuration
        }
        
        self.status = .new
    }
    
    func countNonRestActions() -> Int {
        return actions.filter { $0.type != .rest }.count
    }
    
    private func fetchActions(exercise: ExerciseEntity, in context: NSManagedObjectContext) -> [ActiveWorkoutItemActionViewRepresentation] {
        let fetchedActions = exerciseDataManager.fetchActions(for: exercise, in: context)
        let fetchedRestTime = exerciseDataManager.fetchRestTimeBetweenActions(for: exercise, in: context)

        var actions = [ActiveWorkoutItemActionViewRepresentation]()
        
        var superSetCount: Int
        switch ExerciseType.from(rawValue: exercise.type) {
        case .mixed:
            superSetCount = Int(exercise.superSets)
        default:
            superSetCount = 1
        }
        
        var actionRepetitionsCount: Int
        
        for _ in 0..<superSetCount {
            for (index, action) in fetchedActions.enumerated() {
                switch ExerciseType.from(rawValue: exercise.type) {
                case .setsNreps:
                    actionRepetitionsCount = Int(action.sets)
                default:
                    actionRepetitionsCount = 1
                }
                
                for _ in 0..<actionRepetitionsCount {
                    if let actionRepresentation = action.toActiveWorkoutItemActionViewRepresentation(exerciseName: exercise.name) {
                        if index > 0 {
                            if let restTimeRepresenation = fetchedRestTime?.toActiveWorkoutItemActionViewRepresentation(exerciseName: exercise.name) {
                                actions.append(restTimeRepresenation)
                            }
                        
                        }
                        actions.append(actionRepresentation)
                    }
                }
            }
        }
        return actions
    }
}

extension RestTimeEntity {
    func toActiveWorkoutItemRepresentation() -> ActiveWorkoutItemViewRepresentation? {
        guard let uuid = self.uuid else { return nil }
        guard let context = self.managedObjectContext else { return nil }
        return ActiveWorkoutItemViewRepresentation(entityUUID: uuid, type: .rest, restTimeDuration: self.duration, in: context)
    }
}

extension ExerciseEntity {
    func toActiveWorkoutItemRepresentation() -> ActiveWorkoutItemViewRepresentation? {
        guard let uuid = self.uuid else { return nil }
        guard let context = self.managedObjectContext else { return nil }
        return ActiveWorkoutItemViewRepresentation(entityUUID: uuid, title: self.name, type: .exercise, in: context)
    }
}
