//
//  NewWorkoutModel.swift
//  MyWorkoutPlanner
//
//  Created by aibaranchikov on 29.11.2023.
//

import Foundation
import CoreData

class WorkoutEditTemporaryViewModel: ObservableObject {
    
    private let parentViewModel: WorkoutCarouselViewModel
    let temporaryWorkoutContext: NSManagedObjectContext
    var canUndo: Bool {
        return temporaryWorkoutContext.undoManager?.canUndo ?? false
    }
    var canRedo: Bool {
        return temporaryWorkoutContext.undoManager?.canRedo ?? false
    }
    
    @Published var editingWorkout: WorkoutEntity?
    @Published var exercises: [ExerciseEntity] = []
    @Published var defaultRestTime: RestTimeEntity?
    
    init(parentViewModel: WorkoutCarouselViewModel, editingWorkout: WorkoutEntity? = nil) {
        self.temporaryWorkoutContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.temporaryWorkoutContext.parent = parentViewModel.mainContext
        if self.temporaryWorkoutContext.undoManager == nil {
            self.temporaryWorkoutContext.undoManager = UndoManager()
        }
        self.temporaryWorkoutContext.undoManager?.levelsOfUndo = 10
        
        self.parentViewModel = parentViewModel
        
        if editingWorkout != nil {
            let workoutFetchRequest: NSFetchRequest<WorkoutEntity> = WorkoutEntity.fetchRequest()
            workoutFetchRequest.predicate = NSPredicate(format: "SELF == %@", editingWorkout!.objectID)
            do {
                self.editingWorkout = try self.temporaryWorkoutContext.fetch(workoutFetchRequest).first
            } catch {
                print("Error fetching workout: \(error)")
            }
            self.exercises = self.editingWorkout?.exercises?.array as? [ExerciseEntity] ?? []
            
            self.defaultRestTime = editingWorkout?.restTimes?.first { restTime in
                (restTime as? RestTimeEntity)?.isDefault == true
            } as? RestTimeEntity
            if self.defaultRestTime == nil {
                addOrUpdateDefaultRestTime(withDuration: Constants.DefaultValues.restTimeDuration)
            }
            
        } else {
            addWorkout()
            addOrUpdateDefaultRestTime(withDuration: Constants.DefaultValues.restTimeDuration)
        }
    }
    
    func addWorkout() {
        let newWorkout = WorkoutEntity(context: temporaryWorkoutContext)
        newWorkout.uuid = UUID()
        newWorkout.name = Constants.Design.Placeholders.noWorkoutName
        newWorkout.position = (parentViewModel.workouts.last?.position ?? -1) + 1
        self.editingWorkout = newWorkout
    }
    
    func renameWorkout(newName: String) {
        self.editingWorkout?.name = newName
    }
    
    func addExercise(newExercise: ExerciseEntity) {
        let exerciseFetchRequest: NSFetchRequest<ExerciseEntity> = ExerciseEntity.fetchRequest()
        exerciseFetchRequest.predicate = NSPredicate(format: "SELF == %@", newExercise.objectID)
        
        do {
            let fetchedExercise  = try self.temporaryWorkoutContext.fetch(exerciseFetchRequest).first!
            self.exercises.append(fetchedExercise)
            self.temporaryWorkoutContext.undoManager?.registerUndo(withTarget: self, selector: #selector(redoExerciseDelete(_ :)), object: fetchedExercise)
            self.editingWorkout?.addToExercises(fetchedExercise)
        } catch {
            print("Error fetching exercise for temporary context: \(error)")
        }
    }
    
    func addOrUpdateDefaultRestTime(withDuration duration: Int) {
        if self.defaultRestTime == nil {
            let newDefaultRestTime = RestTimeEntity(context: temporaryWorkoutContext)
            newDefaultRestTime.uuid = UUID()
            newDefaultRestTime.isDefault = true
            newDefaultRestTime.duration = Int32(duration)
            editingWorkout?.addToRestTimes(newDefaultRestTime)
            self.defaultRestTime = newDefaultRestTime
            
        } else {
            self.defaultRestTime?.duration = Int32(duration)
        }
    }
    
    func deleteExercise(exerciseEntity: ExerciseEntity) {
        if let index = exercises.firstIndex(of: exerciseEntity) {
            exercises.remove(at: index)
        }
        self.temporaryWorkoutContext.delete(exerciseEntity)
    }
    
    func deleteWorkoutExercise(at offsets: IndexSet) {
        let exercisesToDelete = offsets.map { self.exercises[$0] }
        exercisesToDelete.forEach { exercise in
            self.temporaryWorkoutContext.undoManager?.registerUndo(withTarget: self, selector: #selector(undoExerciseDelete(_ :)), object: exercise)
            self.exercises.remove(atOffsets: offsets)
            self.temporaryWorkoutContext.delete(exercise)
        }
    }
    
    @objc func undoExerciseDelete(_ exercise: ExerciseEntity) {
        temporaryWorkoutContext.undoManager?.registerUndo(withTarget: self, selector: #selector(redoExerciseDelete(_ :)), object: exercise)
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
    
    @objc func redoExerciseDelete(_ exercise: ExerciseEntity) {
        temporaryWorkoutContext.undoManager?.registerUndo(withTarget: self, selector: #selector(undoExerciseDelete(_ :)), object: exercise)
        if let index = exercises.firstIndex(of: exercise) {
            exercises.remove(at: index)
        }
        self.temporaryWorkoutContext.delete(exercise)
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
        do {
            try temporaryWorkoutContext.parent?.save()
        } catch {
            print("Error saving workout main context: \(error)")
        }
        parentViewModel.refreshData()
    }
    
    func discardWorkout() {
        temporaryWorkoutContext.rollback()
    }
    
    private func saveTemporaryContext() {
        do {
            try temporaryWorkoutContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func undo() {
        temporaryWorkoutContext.undoManager?.undo()
        self.objectWillChange.send()
    }
    
    func redo() {
        temporaryWorkoutContext.undoManager?.redo()
        self.objectWillChange.send()
    }
}
