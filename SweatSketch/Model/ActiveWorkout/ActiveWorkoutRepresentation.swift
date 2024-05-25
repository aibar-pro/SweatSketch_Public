//
//  ActiveWorkoutRepresentation.swift
//  SweatSketch
//
//  Created by aibaranchikov on 02.04.2024.
//

import CoreData

class ActiveWorkoutRepresentation: Identifiable, Equatable, ObservableObject {
    
    static func == (lhs: ActiveWorkoutRepresentation, rhs: ActiveWorkoutRepresentation) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.title == rhs.title &&
            lhs.items == rhs.items
    }
    
    let id: UUID
    var title: String
    
    var items = [ActiveWorkoutItemRepresentation]()
    var currentItemIndex: Int = 0
    var currentActionIndex: Int = 0
    
    var currentItem: ActiveWorkoutItemRepresentation? {
       return items.isEmpty ? nil : items[currentItemIndex]
    }
    
    var currentAction: ActiveWorkoutActionRepresentation? {
       guard !items.isEmpty else { return nil }
       return items[currentItemIndex].actions[currentActionIndex]
    }
    
    private let workoutDataManager = WorkoutDataManager()
    private let exerciseDataManager = ExerciseDataManager()
    
    init(workoutUUID: UUID, in context: NSManagedObjectContext) throws {
        guard let workout = workoutDataManager.fetchWorkout(by: workoutUUID, in: context)
            else { throw ActiveWorkoutError.invalidWorkoutUUID }
        
        self.id = workoutUUID
        self.title = workout.name ?? Constants.Placeholders.noWorkoutName
        
        self.items = fetchItems(for: workout, in: context)
    }
    
    private func fetchItems(for workout: WorkoutEntity, in context: NSManagedObjectContext) -> [ActiveWorkoutItemRepresentation] {
        let fetchedExercises = workoutDataManager.fetchExercises(for: workout, in: context)
        let fetchedDefaultRestTime = workoutDataManager.fetchDefaultRestTime(for: workout, in: context)
        
        // if exercise is not first, if exercise exist: fetch rest time
        // transform fetched rest time or default one
        // add to array of items
        // transform fetched exercise
        // add transformed exercise to an array
        
        var items = [ActiveWorkoutItemRepresentation]()
        
        for (index, exercise) in fetchedExercises.enumerated() {
            if let exerciseRepresentation = exercise.toActiveWorkoutItemRepresentation(defaultWorkoutRestTimeUUID: fetchedDefaultRestTime?.uuid, defaultWorkoutRestTimeDuration: fetchedDefaultRestTime?.duration) {
                //Add rest period between exercises: custom or default
                if index > 0 {
                    if let fetchedRestTime = workoutDataManager.fetchRestTime(for: exercise, in: context), 
                        let restTimeRepresentation = fetchedRestTime.toActiveWorkoutItemRepresentation()
                    {
                        items.append(restTimeRepresentation)
                    } else if let defaultRestTimeDuration = fetchedDefaultRestTime?.duration,
                        let defaultRestTimeRepresentation = ActiveWorkoutItemRepresentation(entityUUID: UUID(), type: .rest, restTimeDuration: defaultRestTimeDuration,in: context)
                    {
                        items.append(defaultRestTimeRepresentation)
                    }
                }
                items.append(exerciseRepresentation)
            }
        }
        
        return items
    }
    
    func next() {
        if currentActionIndex < items[currentItemIndex].actions.count - 1 {
           currentActionIndex += 1
        } else if currentItemIndex < items.count - 1 {
            currentItemIndex += 1
           currentActionIndex = 0
        }
    }

    func previous() {
        if currentActionIndex > 0 {
           currentActionIndex -= 1
        } else if currentItemIndex > 0 {
            currentItemIndex -= 1
           currentActionIndex = items[currentItemIndex].actions.count - 1
        }
    }
    
    func currentItemProgress() -> (current: Int, total: Int) {
        guard let current = currentItem else {
            return (0, 0)
        }
        return (currentActionIndex, current.actions.count)
    }
    
    func isLastAction() -> Bool {
        return currentItemIndex == items.count - 1 && currentActionIndex == items[currentItemIndex].actions.count - 1
    }
}
