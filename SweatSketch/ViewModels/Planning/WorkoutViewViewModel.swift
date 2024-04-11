//
//  WorkoutViewRepresentation.swift
//  SweatSketch
//
//  Created by aibaranchikov on 10.04.2024.
//

import CoreData

class WorkoutViewViewModel: Identifiable, Equatable, ObservableObject {
    static func == (lhs: WorkoutViewViewModel, rhs: WorkoutViewViewModel) -> Bool {
        return 
            lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.exercises == rhs.exercises
    }
    
    let id: UUID
    var name: String
    var exercises = [ExerciseViewViewModel]()
    
    private let workoutDataManager = WorkoutDataManager()
    
    init?(workout: WorkoutEntity, in context: NSManagedObjectContext) {
        guard let id = workout.uuid else { return nil }
        self.id = id
        self.name = workout.name ?? Constants.Placeholders.noWorkoutName
        
        let fetchedExercises = workoutDataManager.fetchExercises(for: workout, in: context)
        self.exercises = fetchedExercises.compactMap({ exercise in
            exercise.toExerciseViewRepresentation()
        })
    }
}

extension WorkoutEntity {
    func toWorkoutViewRepresentation() -> WorkoutViewViewModel? {
        guard let context = self.managedObjectContext else {
            return nil
        }
        return WorkoutViewViewModel(workout: self, in: context)
    }
}
