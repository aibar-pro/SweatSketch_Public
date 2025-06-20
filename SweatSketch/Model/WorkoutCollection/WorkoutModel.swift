//
//  WorkoutViewRepresentation.swift
//  SweatSketch
//
//  Created by aibaranchikov on 10.04.2024.
//

import CoreData

class WorkoutViewRepresentation: Identifiable, ObservableObject {
    let id: UUID
    var name: String
    var exercises = [ExerciseViewRepresentation]()
    
    init?(workout: WorkoutEntity, in context: NSManagedObjectContext) {
        guard let id = workout.uuid else { return nil }
        self.id = id
        self.name = workout.name ?? Constants.Placeholders.noWorkoutName
        
        let workoutDataManager = WorkoutDataManager()
        let fetchedExercises = workoutDataManager.fetchExercises(for: workout, in: context)
        
        switch fetchedExercises {
        case .success(let result):
            self.exercises = result.compactMap { $0.toExerciseViewRepresentation() }
        case .failure(let failure):
            return nil
        }
    }
}

extension WorkoutViewRepresentation: Equatable {
    static func == (lhs: WorkoutViewRepresentation, rhs: WorkoutViewRepresentation) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.exercises == rhs.exercises
    }
}

extension WorkoutEntity {
    func toWorkoutViewRepresentation() -> WorkoutViewRepresentation? {
        guard let context = self.managedObjectContext else {
            return nil
        }
        return WorkoutViewRepresentation(workout: self, in: context)
    }
}
