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
    
    @Published var items = [ActiveWorkoutItem]()
    @Published var currentItemIndex: Int = 0
    @Published var currentStepIndex: Int = 0
    
    var currentItem: ActiveWorkoutItem? {
        return items.isEmpty ? nil : items[safe: currentItemIndex]
    }
    
    var currentAction: ActionRepresentation? {
        guard !items.isEmpty,
                !items[currentItemIndex].actions.isEmpty
        else { return nil }
        
        return items[currentItemIndex].actions[currentStepIndex]
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
        
        // if exercise is not first, if exercise exist: fetch rest time
        // transform fetched rest time or default one
        // add to array of items
        // transform fetched exercise
        // add transformed exercise to an array
        
        var items = [ActiveWorkoutItem]()
        
        for (index, exercise) in fetchedExercises.enumerated() {
            if let exerciseRepresentation = exercise.toActiveWorkoutItem(defaultRest: workout.defaultRest.int) {
                //Add rest period between exercises: custom or default
                if index > 0 {
                    if let preRest = fetchedExercises[safe: index - 1]?.postRest?.intValue {
                        appendRestItem(
                            items: &items,
                            duration: preRest,
                            in: context
                        )
                    } else {
                        appendRestItem(
                            items: &items,
                            duration: workout.defaultRest.int,
                            in: context
                        )
                    }
                }
                items.append(exerciseRepresentation)
            }
        }
        
        return items
    }
    
    private func appendRestItem(
        items: inout [ActiveWorkoutItem],
        duration: Int,
        in context: NSManagedObjectContext
    ) {
        guard let restTimeItem = ActiveWorkoutItem(restTime: duration) else { return }
        
        items.append(restTimeItem)
    }
    
    func next() {
        if currentStepIndex < items[currentItemIndex].actions.count - 1 {
           currentStepIndex += 1
        } else if currentItemIndex < items.count - 1 {
            currentItemIndex += 1
           currentStepIndex = 0
        }
    }

    func previous() {
        if currentStepIndex > 0 {
           currentStepIndex -= 1
        } else if currentItemIndex > 0 {
            currentItemIndex -= 1
            currentStepIndex = items[currentItemIndex].actions.count - 1
        }
    }
    
    func currentItemProgress() -> ItemProgress {
        guard let current = currentItem else {
            return .init()
        }
        
        return ItemProgress(
            stepIndex: currentStepIndex,
            totalSteps: current.actions.count,
            stepProgress: .init()
        )
    }
    
    func isLastStep() -> Bool {
        return currentItemIndex == items.count - 1 && currentStepIndex == items[currentItemIndex].actions.count - 1
    }
}
