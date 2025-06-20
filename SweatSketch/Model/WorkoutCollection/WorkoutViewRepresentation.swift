//
//  WorkoutModel.swift
//  SweatSketch
//
//  Created by aibaranchikov on 10.04.2024.
//

import CoreData

class WorkoutModel: Identifiable, ObservableObject {
    let id: UUID
    var name: String
    var exercises = [ExerciseViewRepresentation]()
    
    init?(workout: WorkoutEntity, in context: NSManagedObjectContext) {
        guard let id = workout.uuid else { return nil }
        self.id = id
        self.name = workout.name ?? Constants.Placeholders.noWorkoutName
        
        let workoutDataManager = WorkoutDataManager()
        let fetchedExercises = workoutDataManager.fetchExercises(for: workout, in: context)
        self.exercises = fetchedExercises.compactMap({ $0.toExerciseViewRepresentation() })
    }
}

extension WorkoutModel: Equatable {
    static func == (lhs: WorkoutModel, rhs: WorkoutModel) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.exercises == rhs.exercises
    }
}

extension WorkoutEntity {
    func toWorkoutViewRepresentation() -> WorkoutModel? {
        guard let context = self.managedObjectContext else {
            return nil
        }
        return WorkoutModel(workout: self, in: context)
    }
}
