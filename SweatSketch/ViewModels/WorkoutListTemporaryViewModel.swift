//
//  WorkoutListTemporaryViewModel.swift
//  SweatSketch
//
//  Created by aibaranchikov on 13.03.2024.
//

import Foundation
import CoreData

class WorkoutListTemporaryViewModel: ObservableObject {

    @Published var workouts = [WorkoutEntity]()
    
    let parentViewModel: WorkoutCarouselViewModel
    private let temporaryWorkoutListContext: NSManagedObjectContext
    var canUndo: Bool {
        return temporaryWorkoutListContext.undoManager?.canUndo ?? false
       }
    var canRedo: Bool {
       return temporaryWorkoutListContext.undoManager?.canRedo ?? false
    }
    
    
    init(parentViewModel: WorkoutCarouselViewModel) {
        self.temporaryWorkoutListContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.temporaryWorkoutListContext.parent = parentViewModel.mainContext
        if self.temporaryWorkoutListContext.undoManager == nil {
            self.temporaryWorkoutListContext.undoManager = UndoManager()
        }
        
        self.parentViewModel = parentViewModel
        
        fetchWorkouts()
    }
    
    private func fetchWorkouts() {
        let request: NSFetchRequest<WorkoutEntity> = WorkoutEntity.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "position", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            workouts = try temporaryWorkoutListContext.fetch(request)
        } catch {
            print("Error fetching workouts for temporary ViewModel: \(error)")
        }
    }
    
    func saveWorkoutListChange() {
        saveTemporaryListContext()
        do {
            try temporaryWorkoutListContext.parent?.save()
        } catch {
            print("Error saving workout main context: \(error)")
        }
        parentViewModel.refreshData()
    }

    func discardWorkoutListChange() {
        temporaryWorkoutListContext.rollback()
    }
    
    private func saveTemporaryListContext() {
        do {
            try temporaryWorkoutListContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
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
