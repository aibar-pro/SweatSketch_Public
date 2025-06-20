//
//  WorkoutEditViewModel.swift
//  MyWorkoutPlanner
//
//  Created by aibaranchikov on 29.11.2023.
//

import CoreData

class WorkoutEditViewModel: ObservableObject {
    
    private let parentViewModel: WorkoutCollectionViewModel
    let mainContext: NSManagedObjectContext
    var canUndo: Bool {
        return mainContext.undoManager?.canUndo ?? false
    }
    var canRedo: Bool {
        return mainContext.undoManager?.canRedo ?? false
    }
    
    @Published var editingWorkout: WorkoutEntity
    @Published var exercises = [ExerciseEntity]()
    @Published var defaultRestTime: RestTimeEntity
    
    private let collectionDataManager = CollectionDataManager()
    private let workoutDataManager = WorkoutDataManager()
    private let exerciseDataManager = ExerciseDataManager()
    
    init?(parentViewModel: WorkoutCollectionViewModel, editingWorkoutUUID: UUID? = nil) {
        self.mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.mainContext.parent = parentViewModel.mainContext
        self.parentViewModel = parentViewModel
        
        if self.mainContext.undoManager == nil {
            self.mainContext.undoManager = UndoManager()
        }
        self.mainContext.undoManager?.levelsOfUndo = 10
        self.mainContext.undoManager?.beginUndoGrouping()
        
        self.editingWorkout = WorkoutEntity()
        self.defaultRestTime = RestTimeEntity()
        
        if let workoutUUID = editingWorkoutUUID,
            let workoutToEdit = workoutDataManager.fetchWorkout(by: workoutUUID, in: self.mainContext) {
            
            self.editingWorkout = workoutToEdit
            
            let result = workoutDataManager.fetchExercises(for: workoutToEdit, in: self.mainContext)
            switch result {
                case .success(let fetchedExercises):
                self.exercises = fetchedExercises
            case .failure(let error):
                print("\(type(of: self)): Failed to fetch exercises for workout: \(error)")
                return nil
            }
        } else {
            self.editingWorkout = collectionDataManager.createWorkout(for: self.parentViewModel.workoutCollection, in: self.mainContext)
        }
        
        //Setup default workout rest time
        if let defaultRestTime = workoutDataManager.fetchDefaultRestTime(for: self.editingWorkout, in: self.mainContext) {
            self.defaultRestTime = defaultRestTime
        } else {
            guard let createdRestTime = createDefaultRestTime(withDuration: Constants.DefaultValues.restTimeDuration) else { return nil }
            self.defaultRestTime = createdRestTime
        }
        
        //Ignore Workout and default RestTime creation for undo/redo
        self.mainContext.undoManager?.endUndoGrouping()
        self.mainContext.undoManager?.removeAllActions()
    }
    
    func renameWorkout(newName: String) {
        self.editingWorkout.name = newName
    }
    
    //Used for correct implementation of add exercise undo
    func addExerciseToWorkout(newExercise: ExerciseEntity) {
        if let fetchedExercise = exerciseDataManager.fetchExercise(exercise: newExercise, in: self.mainContext) {
            self.mainContext.undoManager?.registerUndo(withTarget: self, selector: #selector(redoExerciseDelete(_ :)), object: fetchedExercise)
            self.editingWorkout.addToExercises(fetchedExercise)
        }
    }
    
    func createDefaultRestTime(withDuration duration: Int) -> RestTimeEntity? {
        let result = workoutDataManager
            .createDefaultRestTime(
                for: self.editingWorkout,
                with: duration,
                in: self.mainContext
            )
        
        if case .success(let success) = result {
            return success
        } else {
            return nil
        }
    }
    
    func updateDefaultRestTime(duration: Int) {
        self.defaultRestTime.duration = duration.int32
    }
    
    func deleteExercise(exerciseEntity: ExerciseEntity) {
        if let index = exercises.firstIndex(of: exerciseEntity) {
            exercises.remove(at: index)
        }
        self.mainContext.delete(exerciseEntity)
    }
    
    func deleteWorkoutExercise(at offsets: IndexSet) {
        let exercisesToDelete = offsets.map { self.exercises[$0] }
        exercisesToDelete.forEach { exercise in
            self.mainContext.undoManager?.registerUndo(withTarget: self, selector: #selector(undoExerciseDelete(_ :)), object: exercise)
            self.exercises.remove(atOffsets: offsets)
            self.mainContext.delete(exercise)
        }
    }
    
    @objc func undoExerciseDelete(_ exercise: ExerciseEntity) {
        mainContext.undoManager?.registerUndo(withTarget: self, selector: #selector(redoExerciseDelete(_ :)), object: exercise)
        var low: Int = 0
        var high = exercises.count
        
        while low < high {
            let mid = low + (high - low) / 2
            if exercises[mid].position < exercise.position {
                low = mid + 1
            } else {
                high = mid
            }
        }
        exercises.insert(exercise, at: low)
    }
    
    @objc func redoExerciseDelete(_ exercise: ExerciseEntity) {
        mainContext.undoManager?.registerUndo(
            withTarget: self,
            selector: #selector(undoExerciseDelete(_ :)),
            object: exercise
        )
        if let index = exercises.firstIndex(of: exercise) {
            exercises.remove(at: index)
        }
        self.mainContext.delete(exercise)
    }
    
    func reorderWorkoutExercise(from source: IndexSet, to destination: Int) {
        exercises.move(fromOffsets: source, toOffset: destination)
        
        exercises.enumerated().forEach{ index, exercise in
            editingWorkout.removeFromExercises(exercise)
            editingWorkout.insertIntoExercises(exercise, at: index)
            exercise.position = Int16(index)
        }
    }
    
    func saveWorkout() {
        do {
            try mainContext.save()
            parentViewModel.saveContext()
            parentViewModel.refreshData()
        } catch {
            print("\(type(of: self)): \(#function): Error saving workout context: \(error)")
        }
    }
    
    func discardWorkout() {
        mainContext.rollback()
    }
    
    func refreshData() {
        do {
            self.exercises = try workoutDataManager.fetchExercises(for: self.editingWorkout, in: self.mainContext).get()
            self.objectWillChange.send()
        } catch {
            print("\(type(of: self)): \(#function): Error fetching exercises: \(error)")
        }
    }
    
    func undo() {
        mainContext.undoManager?.undo()
        self.objectWillChange.send()
    }
    
    func redo() {
        mainContext.undoManager?.redo()
        self.objectWillChange.send()
    }
}
