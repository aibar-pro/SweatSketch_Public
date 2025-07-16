//
//  ExerciseRepresentation.swift
//  SweatSketch
//
//  Created by aibaranchikov on 09.04.2024.
//

import CoreData

class ExerciseRepresentation: Identifiable, ObservableObject {
    let id: UUID
    var name: String
    var actions = [ActionRepresentation]()
    var restTimeBetweenActions: Int?
    var superSets: Int
    
    init?(exercise: ExerciseEntity, in context: NSManagedObjectContext) {
        guard let id = exercise.uuid else { return nil }
        self.id = id
        let name = exercise.name ?? Constants.Placeholders.noExerciseName
        self.name = name
        
        let exerciseDataManager = ExerciseDataManager()
        
        let fetchedActions = exerciseDataManager.fetchActions(for: exercise, in: context)
        self.actions = fetchedActions.compactMap { $0.toActionViewRepresentation(exerciseName: name) }
        
        self.restTimeBetweenActions = exercise.intraRest.intValue

        self.superSets = exercise.superSets.int
    }
}

extension ExerciseRepresentation: Equatable {
    static func == (lhs: ExerciseRepresentation, rhs: ExerciseRepresentation) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.actions == rhs.actions &&
            lhs.restTimeBetweenActions == rhs.restTimeBetweenActions &&
            lhs.superSets == rhs.superSets
    }
}

extension ExerciseEntity {
    func toExerciseRepresentation() -> ExerciseRepresentation? {
        guard let context = self.managedObjectContext else {
            return nil
        }
        return ExerciseRepresentation(exercise: self, in: context)
    }
}
