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
    
    var items = [ActiveWorkoutItem]()
    var currentItemIndex: Int = 0
    var currentActionIndex: Int = 0
    
    var currentItem: ActiveWorkoutItem? {
       return items.isEmpty ? nil : items[currentItemIndex]
    }
    
    var currentAction: ActionRepresentation? {
        guard !items.isEmpty,
                !items[currentItemIndex].actions.isEmpty
        else { return nil }
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
    
    private func fetchItems(for workout: WorkoutEntity, in context: NSManagedObjectContext) -> [ActiveWorkoutItem] {
        guard case .success(let fetchedExercises) = workoutDataManager.fetchExercises(for: workout, in: context),
                !fetchedExercises.isEmpty
        else { return [] }
        
        let defaultRestDuration = fetchDefaultRestTimeDuration(for: workout, in: context)
        
        // if exercise is not first, if exercise exist: fetch rest time
        // transform fetched rest time or default one
        // add to array of items
        // transform fetched exercise
        // add transformed exercise to an array
        
        var items = [ActiveWorkoutItem]()
        
        for (index, exercise) in fetchedExercises.enumerated() {
            if let exerciseRepresentation = exercise.toActiveWorkoutItem(defaultRestDuration: defaultRestDuration) {
                //Add rest period between exercises: custom or default
                if index > 0 {
                    if let fetchedRestTime = workoutDataManager.fetchRestTime(for: exercise, in: context), 
                        let restTimeRepresentation = fetchedRestTime.toActiveWorkoutItem() {
                        items.append(restTimeRepresentation)
                    } else {
                        appendDefaultRestTime(items: &items, duration: defaultRestDuration, in: context)
                    }
                }
                items.append(exerciseRepresentation)
            }
        }
        
        return items
    }
    
    private func fetchDefaultRestTimeDuration(for workout: WorkoutEntity, in context: NSManagedObjectContext) -> Int {
        guard let fetchedDefaultRestTime = workoutDataManager.fetchDefaultRestTime(for: workout, in: context) else { return 0 }
        return fetchedDefaultRestTime.duration.int
    }
    
    private func appendDefaultRestTime(
        items: inout [ActiveWorkoutItem],
        duration: Int,
        in context: NSManagedObjectContext
    ) {
        guard let restTimeItem = ActiveWorkoutItem(
            entityUUID: UUID(),
            title: Constants.Placeholders.restPeriodLabel,
            kind: .rest(duration: duration),
            in: context
        ) else { return }
        
        items.append(
            restTimeItem
        )
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
