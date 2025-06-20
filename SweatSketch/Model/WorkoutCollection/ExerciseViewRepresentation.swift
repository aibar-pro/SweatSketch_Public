//
//  ExerciseViewModel.swift
//  SweatSketch
//
//  Created by aibaranchikov on 09.04.2024.
//

import CoreData

class ExerciseModel: Identifiable, Equatable, ObservableObject {
    let id: UUID
    var name: String
    var actions = [ExerciseActionModel]()
    var restTimeBetweenActions: RestActionEntity?
    var superSets: Int16
    
    init?(exercise: ExerciseEntity, in context: NSManagedObjectContext) {
        guard let id = exercise.uuid else { return nil }
        self.id = id
        let name = exercise.name ?? Constants.Placeholders.noExerciseName
        self.name = name
        
        let exerciseDataManager = ExerciseDataManager()
        let fetchedActions = exerciseDataManager.fetchActions(for: exercise, in: context)
//        self.actions = fetchedActions.compactMap { $0.toExerciseActionModel(exerciseName: name) }
        
        self.restTimeBetweenActions = exerciseDataManager.fetchRestTimeBetweenActions(for: exercise, in: context)
        self.superSets = exercise.superSets
    }
}

extension ExerciseModel {
    static func == (lhs: ExerciseModel, rhs: ExerciseModel) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.actions == rhs.actions &&
            lhs.restTimeBetweenActions == rhs.restTimeBetweenActions &&
            lhs.superSets == rhs.superSets
    }
}

extension ExerciseEntity {
    func toExerciseViewRepresentation() -> ExerciseModel? {
        guard let context = self.managedObjectContext else {
            return nil
        }
        return ExerciseModel(exercise: self, in: context)
    }
}
