//
//  ActiveWorkoutViewRepresentation.swift
//  SweatSketch
//
//  Created by aibaranchikov on 02.04.2024.
//

import CoreData

class ActiveWorkoutViewRepresentation: Identifiable, Equatable, ObservableObject {
    
    static func == (lhs: ActiveWorkoutViewRepresentation, rhs: ActiveWorkoutViewRepresentation) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.title == rhs.title &&
            lhs.items == rhs.items
    }
    
    let id: UUID
    var title: String
    var items = [ActiveWorkoutItemViewRepresentation]()
    
    private let workoutDataManager = WorkoutDataManager()
    private let exerciseDataManager = ExerciseDataManager()
    
    init(workoutUUID: UUID, in context: NSManagedObjectContext) throws {
        guard let workout = workoutDataManager.fetchWorkout(by: workoutUUID, in: context)
            else { throw ActiveWorkoutError.invalidWorkoutUUID }
        
        self.id = workoutUUID
        self.title = workout.name ?? Constants.Placeholders.noWorkoutName
        
        self.items = fetchItems(for: workout, in: context)
    }
    
    private func fetchItems(for workout: WorkoutEntity, in context: NSManagedObjectContext) -> [ActiveWorkoutItemViewRepresentation] {
        let fetchedExercises = workoutDataManager.fetchExercises(for: workout, in: context)
        let fetchedDefaultRestTime = workoutDataManager.fetchDefaultRestTime(for: workout, in: context)
        
        // if exercise is not first, if exercise exist: fetch rest time
        // transform fetched rest time or default one
        // add to array of items
        // transform fetched exercise
        // add transformed exercise to an array
        
        var items = [ActiveWorkoutItemViewRepresentation]()
        
        for (index, exercise) in fetchedExercises.enumerated() {
            if let exerciseRepresentation = exercise.toActiveWorkoutItemRepresentation(defaultWorkoutRestTimeUUID: fetchedDefaultRestTime?.uuid, defaultWorkoutRestTimeDuration: fetchedDefaultRestTime?.duration) {
                //Add rest period between exercises: custom or default
                if index > 0 {
                    if let fetchedRestTime = workoutDataManager.fetchRestTime(for: exercise, in: context), let restTimeRepresentation = fetchedRestTime.toActiveWorkoutItemRepresentation() {
                        items.append(restTimeRepresentation)
//                    } else if let defaultRestTimeRepresentation = fetchedDefaultRestTime?.toActiveWorkoutItemRepresentation() {
//                        items.append(defaultRestTimeRepresentation)
//                    }
                    } else if 
                        let defaultRestTimeDuration = fetchedDefaultRestTime?.duration,
                        let defaultRestTimeRepresentation = ActiveWorkoutItemViewRepresentation(entityUUID: UUID(), type: .rest, restTimeDuration: defaultRestTimeDuration,in: context)
                    {
                        items.append(defaultRestTimeRepresentation)
                    }
                }
                items.append(exerciseRepresentation)
            }
        }
        
        return items
    }
}
