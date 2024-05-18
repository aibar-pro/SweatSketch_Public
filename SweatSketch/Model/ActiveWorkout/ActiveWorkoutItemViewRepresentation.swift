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
    
    // I've decided yet how to pass default workout rest time, but I need it for unwrapping workout
    init?(entityUUID: UUID, title: String? = nil, type: ActiveWorkoutItemType, restTimeDuration: Int32? = nil, defaultWorkoutRestTimeUUID: UUID? = nil, in context: NSManagedObjectContext) {
        self.id = UUID()
        self.entityUUID = entityUUID
        
        self.type = type
        
        switch type {
        case .exercise:
            guard let exercise = exerciseDataManager.fetchExercise(by: entityUUID, in: context) else { return nil }
            self.title = title ?? Constants.Placeholders.noExerciseName
            self.actions = fetchActions(exercise: exercise, defaultWorkoutRestTimeUUID: defaultWorkoutRestTimeUUID, defaultWorkoutRestTimeDuration: restTimeDuration, in: context)
        case .rest:
            self.title = Constants.Placeholders.restPeriodLabel
            self.restTimeDuration = restTimeDuration
        }
        
        self.status = .new
    }
    
    func countNonRestActions() -> Int {
        return actions.filter { $0.type != .rest }.count
    }
    
    private func fetchActions(exercise: ExerciseEntity, defaultWorkoutRestTimeUUID: UUID? = nil, defaultWorkoutRestTimeDuration: Int32? = nil, in context: NSManagedObjectContext) -> [ActiveWorkoutItemActionViewRepresentation] {
        let fetchedActions = exerciseDataManager.fetchActions(for: exercise, in: context)
       
        var exerciseRestTimeRepresentation: ActiveWorkoutItemActionViewRepresentation {
            if let fetchedRestTime = exerciseDataManager.fetchRestTimeBetweenActions(for: exercise, in: context), 
                let restTimeRepresentation = fetchedRestTime.toActiveWorkoutItemActionViewRepresentation(exerciseName: exercise.name) {
                return restTimeRepresentation
            } else if let workoutRestTimeUUID = defaultWorkoutRestTimeUUID, 
                        let workoutRestTimeDuration = defaultWorkoutRestTimeDuration, let workoutRestTimeRepresentation = ActiveWorkoutItemActionViewRepresentation(entityUUID: workoutRestTimeUUID, type: .rest, duration: workoutRestTimeDuration) {
                return workoutRestTimeRepresentation
            } else {
                //TODO: Consider remove force unwrapping
                return ActiveWorkoutItemActionViewRepresentation(entityUUID: UUID(), type: .rest, duration: Int32(Constants.DefaultValues.restTimeDuration))!
            }
        }
        
        var actions = [ActiveWorkoutItemActionViewRepresentation]()
        
        var supersetCount: Int
        var isSuperset = false
        
        switch ExerciseType.from(rawValue: exercise.type) {
        case .mixed:
            supersetCount = Int(exercise.superSets)
            isSuperset = true
        default:
            supersetCount = 1
        }
        
        var actionRepetitionsCount: Int
        
        for supersetIndex in 0..<supersetCount {
            if supersetIndex > 0,
                let appendedRestTimeDuration = exerciseRestTimeRepresentation.duration,
                appendedRestTimeDuration > 0 {
                actions.append(exerciseRestTimeRepresentation)
            }
            for (actionIndex, action) in fetchedActions.enumerated() {
                if actionIndex > 0,
                   let appendedRestTimeDuration = exerciseRestTimeRepresentation.duration,
                   appendedRestTimeDuration > 0 {
                    actions.append(exerciseRestTimeRepresentation)
                }
                
                if ExerciseType.from(rawValue: exercise.type) == .setsNreps {
                    actionRepetitionsCount = Int(action.sets)
                } else {
                    actionRepetitionsCount = 1
                }
                
                for setsIndex in 0..<actionRepetitionsCount {
                    if let actionRepresentation = action.toActiveWorkoutItemActionViewRepresentation(exerciseName: !isSuperset ? exercise.name : nil) {
                        if setsIndex > 0,
                           let appendedRestTimeDuration = exerciseRestTimeRepresentation.duration,
                           appendedRestTimeDuration > 0 {
                            actions.append(exerciseRestTimeRepresentation)
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
    func toActiveWorkoutItemRepresentation(defaultWorkoutRestTimeUUID: UUID? = nil, defaultWorkoutRestTimeDuration: Int32? = nil) -> ActiveWorkoutItemViewRepresentation? {
        guard let uuid = self.uuid else { return nil }
        guard let context = self.managedObjectContext else { return nil }
        return ActiveWorkoutItemViewRepresentation(entityUUID: uuid, title: self.name, type: .exercise, restTimeDuration: defaultWorkoutRestTimeDuration, defaultWorkoutRestTimeUUID: defaultWorkoutRestTimeUUID, in: context)
    }
}
