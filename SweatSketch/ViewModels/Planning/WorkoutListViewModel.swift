//
//  WorkoutListViewModel.swift
//  SweatSketch
//
//  Created by aibaranchikov on 13.03.2024.
//

import CoreData

class WorkoutListViewModel: ObservableObject {

    private let temporaryWorkoutListContext: NSManagedObjectContext
    private let parentViewModel: WorkoutCarouselViewModel
    
    let workoutCollection: WorkoutCollectionEntity
    @Published var workouts = [WorkoutEntity]()
    
    private let collectionDataManager = CollectionDataManager()
    
    var canUndo: Bool {
        return temporaryWorkoutListContext.undoManager?.canUndo ?? false
       }
    var canRedo: Bool {
       return temporaryWorkoutListContext.undoManager?.canRedo ?? false
    }
    
    init(parentViewModel: WorkoutCarouselViewModel, workoutCollection: WorkoutCollectionEntity) {
        self.temporaryWorkoutListContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        self.temporaryWorkoutListContext.parent = parentViewModel.mainContext
        if self.temporaryWorkoutListContext.undoManager == nil {
            self.temporaryWorkoutListContext.undoManager = UndoManager()
        }
        self.parentViewModel = parentViewModel
        
        self.workoutCollection = workoutCollection
        
        self.workouts = collectionDataManager.fetchWorkouts(for: self.workoutCollection, in: self.temporaryWorkoutListContext)
    }
    
    func saveWorkoutListChange() {
        do {
            try temporaryWorkoutListContext.save()
            parentViewModel.saveContext()
        } catch {
            print("Error saving workout main context: \(error)")
        }
        parentViewModel.refreshData()
    }

    func discardWorkoutListChange() {
        temporaryWorkoutListContext.rollback()
    }
    
    func deleteWorkout(offsets: IndexSet) {
        let workoutsToDelete = offsets.map { self.workouts[$0] }
        workoutsToDelete.forEach { workout in
            temporaryWorkoutListContext.undoManager?.registerUndo(withTarget: self, selector: #selector(undoWorkoutDelete(_ :)), object: workout)
            self.workouts.remove(atOffsets: offsets)
            self.temporaryWorkoutListContext.delete(workout)
        }
    }
    
    @objc func undoWorkoutDelete(_ workout: WorkoutEntity) {
        temporaryWorkoutListContext.undoManager?.registerUndo(withTarget: self, selector: #selector(redoWorkoutDelete(_ :)), object: workout)
        var low: Int = 0
        var high = workouts.count

        while low < high {
            let mid = low + (high - low) / 2
            if workouts[mid].position < workout.position {
                low = mid + 1
            } else {
                high = mid
            }
        }
        workouts.insert(workout, at: low)
    }
    
    @objc func redoWorkoutDelete(_ workout: WorkoutEntity) {
        temporaryWorkoutListContext.undoManager?.registerUndo(withTarget: self, selector: #selector(undoWorkoutDelete(_ :)), object: workout)
        if let index = workouts.firstIndex(of: workout) {
            workouts.remove(at: index)
        }
        temporaryWorkoutListContext.delete(workout)
    }
    
    func moveWorkout(source: IndexSet, destination: Int) {
        self.temporaryWorkoutListContext.undoManager?.beginUndoGrouping()
        
        //TODO: Optimize memory usage
        let originalOrder = self.workouts
        temporaryWorkoutListContext.undoManager?.registerUndo(withTarget: self, handler: { [weak self] _ in
               self?.revertWorkoutOrder(originalOrder)
           })
        
        workouts.move(fromOffsets: source, toOffset: destination)
       
        workouts.enumerated().forEach{ index, workout in
            workout.position = Int16(index)
        }
        
        self.temporaryWorkoutListContext.undoManager?.endUndoGrouping()
    }
    
    func revertWorkoutOrder(_ originalWorkoutOrder: [WorkoutEntity]) {
        self.temporaryWorkoutListContext.undoManager?.beginUndoGrouping()
        
        let originalOrder = self.workouts
        temporaryWorkoutListContext.undoManager?.registerUndo(withTarget: self, handler: { [weak self] _ in
               self?.revertWorkoutOrder(originalOrder)
           })
        
        workouts = originalWorkoutOrder
        
        workouts.enumerated().forEach{ index, workout in
            workout.position = Int16(index)
        }
        
        self.temporaryWorkoutListContext.undoManager?.endUndoGrouping()
    }

    func undo() {
        temporaryWorkoutListContext.undoManager?.undo()
        self.objectWillChange.send()
    }
        
    func redo() {
        temporaryWorkoutListContext.undoManager?.redo()
        self.objectWillChange.send()
    }
}
