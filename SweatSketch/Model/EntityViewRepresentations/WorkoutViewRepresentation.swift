//
//  WorkoutViewRepresentation.swift
//  SweatSketch
//
//  Created by aibaranchikov on 10.04.2024.
//

import CoreData

class WorkoutViewRepresentation: Identifiable, Equatable, ObservableObject {
    static func == (lhs: WorkoutViewRepresentation, rhs: WorkoutViewRepresentation) -> Bool {
        return 
            lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.exercises == rhs.exercises
    }
    
    let id: UUID
    var name: String
    var exercises = [ExerciseViewRepresentation]()
    
    private let workoutDataManager = WorkoutDataManager()
    
    init?(workout: WorkoutEntity, in context: NSManagedObjectContext) {
        guard let id = workout.uuid else { return nil }
        self.id = id
        self.name = workout.name ?? Constants.Placeholders.noWorkoutName
        
        let fetchedExercises = workoutDataManager.fetchExercises(for: workout, in: context)
        self.exercises = fetchedExercises.compactMap({ $0.toExerciseViewRepresentation() })
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
