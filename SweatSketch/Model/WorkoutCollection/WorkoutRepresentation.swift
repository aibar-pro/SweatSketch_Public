//
//  WorkoutRepresentation.swift
//  SweatSketch
//
//  Created by aibaranchikov on 10.04.2024.
//

import CoreData

class WorkoutRepresentation: Identifiable, ObservableObject {
    let id: UUID
    var name: String
    var exercises = [ExerciseRepresentation]()
    
    init?(
        workout: WorkoutEntity,
        in context: NSManagedObjectContext,
        includeContent: Bool = true
    ) {
        guard let id = workout.uuid else { return nil }
        self.id = id
        self.name = workout.name ?? Constants.Placeholders.noWorkoutName
        
        if includeContent {
            let workoutDataManager = WorkoutDataManager()
            let fetchedExercises = workoutDataManager.fetchExercises(for: workout, in: context)
            
            switch fetchedExercises {
            case .success(let result):
                self.exercises = result.compactMap { $0.toExerciseRepresentation() }
            case .failure:
                return nil
            }
        }
    }
}

extension WorkoutRepresentation: Equatable {
    static func == (lhs: WorkoutRepresentation, rhs: WorkoutRepresentation) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.exercises == rhs.exercises
    }
}

extension WorkoutEntity {
    func toWorkoutRepresentation(includeContent: Bool = true) -> WorkoutRepresentation? {
        guard let context = self.managedObjectContext else {
            return nil
        }
        return WorkoutRepresentation(
            workout: self,
            in: context,
            includeContent: true
        )
    }
}
