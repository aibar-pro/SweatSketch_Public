//
//  NewWorkoutModel.swift
//  MyWorkoutPlanner
//
//  Created by aibaranchikov on 29.11.2023.
//

import Foundation
import CoreData

class WorkoutEditTemporaryViewModel: ObservableObject {
    
    let parentViewModel: WorkoutCarouselViewModel
    let temporaryContext: NSManagedObjectContext
    var canUndo: Bool {
        return temporaryContext.undoManager?.canUndo ?? false
       }
    var canRedo: Bool {
       return temporaryContext.undoManager?.canRedo ?? false
    }
    
    @Published var editingWorkout: WorkoutEntity?
    @Published var exercises: [ExerciseEntity] = []
    
    init(parentViewModel: WorkoutCarouselViewModel, editingWorkout: WorkoutEntity? = nil) {
        self.temporaryContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.temporaryContext.parent = parentViewModel.mainContext
        if self.temporaryContext.undoManager == nil {
            self.temporaryContext.undoManager = UndoManager()
        }
        self.temporaryContext.undoManager?.levelsOfUndo = 10
        
        self.parentViewModel = parentViewModel
        
        if editingWorkout != nil {
            let workoutFetchRequest: NSFetchRequest<WorkoutEntity> = WorkoutEntity.fetchRequest()
            workoutFetchRequest.predicate = NSPredicate(format: "SELF == %@", editingWorkout!.objectID)
            do {
                self.editingWorkout = try self.temporaryContext.fetch(workoutFetchRequest).first
            } catch {
                print("Error fetching workout: \(error)")
            }
            self.exercises = self.editingWorkout?.exercises?.array as? [ExerciseEntity] ?? []
        } else {
            addWorkout()
        }
    }

    func addWorkout() {
        let newWorkout = WorkoutEntity(context: temporaryContext)
        newWorkout.uuid = UUID()
        newWorkout.name = Constants.Design.Placeholders.noWorkoutName
        newWorkout.position = (parentViewModel.workouts.last?.position ?? -1) + 1
        self.editingWorkout = newWorkout
    }

    func renameWorkout(newName: String) {
        self.editingWorkout?.name = newName
    }
    
    func addWorkoutExercise(newExercise: ExerciseEntity) {
        self.exercises.append(newExercise)
        self.editingWorkout?.addToExercises(newExercise)
    }
    
    func deleteWorkoutExercise(at offsets: IndexSet) {
        let exercisesToDelete = offsets.map { self.exercises[$0] }
        exercisesToDelete.forEach { exercise in
            self.exercises.remove(atOffsets: offsets)
            self.temporaryContext.delete(exercise)
        }
    }
    
    func reorderWorkoutExercise(from source: IndexSet, to destination: Int) {
        exercises.move(fromOffsets: source, toOffset: destination)
        
        exercises.enumerated().forEach{ index, exercise in
            editingWorkout?.removeFromExercises(exercise)
            editingWorkout?.insertIntoExercises(exercise, at: index)
            exercise.order=Int16(index)
        }
    }
    
    func saveWorkout() {
        saveTemporaryContext()
        parentViewModel.refreshData()
    }
    
    func discardWorkout() {
        temporaryContext.rollback()
    }
    
    private func saveTemporaryContext() {
        do {
            try temporaryContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func undo() {
        temporaryContext.undoManager?.undo()
        self.objectWillChange.send()
    }
        
    func redo() {
        temporaryContext.undoManager?.redo()
        self.objectWillChange.send()
    }
    
    func undoAddExercise(for exercise: ExerciseEntity) {
        
        self.temporaryContext.undoManager?.registerUndo(withTarget: self, handler: { [weak self] _ in
            self?.redoAddExercise(for: exercise)
        })
        if let index = exercises.firstIndex(of: exercise) {
            exercises.remove(at: index)
        }
        self.temporaryContext.delete(exercise)
    }
    
    func redoAddExercise(for exercise: ExerciseEntity) {
        
        self.temporaryContext.undoManager?.registerUndo(withTarget: self, handler: { [weak self] _ in
            self?.undoAddExercise(for: exercise)
        })
        
        var low: Int = 0
        var high = exercises.count

        while low < high {
            let mid = low + (high - low) / 2
            if exercises[mid].order < exercise.order {
                low = mid + 1
            } else {
                high = mid
            }
        }
        exercises.insert(exercise, at: low)
    }
}
