//
//  ExerciseViewRepresentation.swift
//  SweatSketch
//
//  Created by aibaranchikov on 09.04.2024.
//

import CoreData

class ExerciseViewRepresentation: Identifiable, ObservableObject {
    let id: UUID
    var name: String
    var actions = [ActionViewRepresentation]()
    var restTimeBetweenActions: RestActionEntity?
    var superSets: Int
    
    init?(exercise: ExerciseEntity, in context: NSManagedObjectContext) {
        guard let id = exercise.uuid else { return nil }
        self.id = id
        let name = exercise.name ?? Constants.Placeholders.noExerciseName
        self.name = name
        
        let exerciseDataManager = ExerciseDataManager()
        
        let fetchedActions = exerciseDataManager.fetchActions(for: exercise, in: context)
        self.actions = fetchedActions.compactMap { $0.toActionViewRepresentation(exerciseName: name) }
        
        self.restTimeBetweenActions = exerciseDataManager.fetchRestTimeBetweenActions(for: exercise, in: context)

        self.superSets = exercise.superSets.int
    }
}

extension ExerciseViewRepresentation: Equatable {
    static func == (lhs: ExerciseViewRepresentation, rhs: ExerciseViewRepresentation) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.actions == rhs.actions &&
            lhs.restTimeBetweenActions == rhs.restTimeBetweenActions &&
            lhs.superSets == rhs.superSets
    }
}

extension ExerciseEntity {
    func toExerciseViewRepresentation() -> ExerciseViewRepresentation? {
        guard let context = self.managedObjectContext else {
            return nil
        }
        return ExerciseViewRepresentation(exercise: self, in: context)
    }
}
