//
//  WorkoutEditorModel.swift
//  MyWorkoutPlanner
//
//  Created by aibaranchikov on 29.11.2023.
//

import CoreData

class WorkoutEditorModel: ObservableObject {
    
    private let parent: WorkoutCollectionViewModel
    let context: NSManagedObjectContext
    var canUndo: Bool {
        return context.undoManager?.canUndo ?? false
    }
    var canRedo: Bool {
        return context.undoManager?.canRedo ?? false
    }
    
    @Published var workout: WorkoutEntity
    @Published var exercises: [ExerciseRepresentation] = []
    @Published var defaultRestTime: RestTimeEntity
    
    private let collectionDataManager = CollectionDataManager()
    private let workoutDataManager = WorkoutDataManager()
    private let exerciseDataManager = ExerciseDataManager()
    
    init?(parent: WorkoutCollectionViewModel, editingWorkoutUUID: UUID? = nil) {
        self.context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.context.parent = parent.context
        self.parent = parent
        
        if self.context.undoManager == nil {
            self.context.undoManager = UndoManager()
        }
        self.context.undoManager?.levelsOfUndo = Constants.Data.undoLevelsLimit
        self.context.undoManager?.disableUndoRegistration()
        
        self.workout = WorkoutEntity()
        self.defaultRestTime = RestTimeEntity()
        
        if let workoutUUID = editingWorkoutUUID,
            let workoutToEdit = workoutDataManager.fetchWorkout(by: workoutUUID, in: self.context) {
            
            self.workout = workoutToEdit
            
            reloadExercises()
        } else {
            self.workout = collectionDataManager.createWorkout(for: self.parent.workoutCollection, in: self.context)
        }
        
        //Setup default workout rest time
        if let defaultRestTime = workoutDataManager.fetchDefaultRestTime(for: self.workout, in: self.context) {
            self.defaultRestTime = defaultRestTime
        } else {
            guard let createdRestTime = createDefaultRestTime(withDuration: Constants.DefaultValues.restTimeDuration) else { return nil }
            self.defaultRestTime = createdRestTime
        }
        
        self.context.undoManager?.enableUndoRegistration()
    }
    
    func renameWorkout(newName: String) {
        self.workout.name = newName
    }
    
    func createDefaultRestTime(withDuration duration: Int) -> RestTimeEntity? {
        let result = workoutDataManager
            .createDefaultRestTime(
                for: self.workout,
                with: duration,
                in: self.context
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
    
    func moveExercises(from source: IndexSet, to destination: Int) {
        exercises.move(fromOffsets: source, toOffset: destination)
        
        context.undoManager?.beginUndoGrouping()
        defer { context.undoManager?.endUndoGrouping() }
        
        let positions = Dictionary(
            uniqueKeysWithValues: exercises.enumerated().map { idx, repr in
                (repr.id, idx)
            }
        )
        positions.forEach { idx, pos in
            if let exercise = exerciseDataManager.fetchExercise(by: idx, in: context) {
                context.undoManager?.registerUndo(
                    withTarget: self,
                    selector: #selector(undoExerciseMove(_ :)),
                    object: exercise
                )
            }
        }
        workoutDataManager.updateExercisePositions(positions, for: workout, in: context)
    }
    
    func deleteExercises(at offsets: IndexSet) {
        context.undoManager?.beginUndoGrouping()
        defer { context.undoManager?.endUndoGrouping() }
        
        let toDelete = offsets.map { exercises[$0].id }
        toDelete.forEach { id in
            if let exercise = exerciseDataManager.fetchExercise(by: id, in: context) {
                context.undoManager?.registerUndo(
                    withTarget: self,
                    selector: #selector(undoExerciseDelete(_ :)),
                    object: exercise
                )
            }
            exerciseDataManager.removeExercise(with: id, in: context)
        }
        
        exercises.remove(atOffsets: offsets)
    }
    
    @objc func undoExerciseDelete(_ exercise: ExerciseEntity) {
        context.undoManager?.beginUndoGrouping()
        defer { context.undoManager?.endUndoGrouping() }
        
        context.undoManager?.registerUndo(
            withTarget: self,
            selector: #selector(redoExerciseDelete(_ :)),
            object: exercise
        )
        reloadExercises()
    }
    
    @objc func redoExerciseDelete(_ exercise: ExerciseEntity) {
        context.undoManager?.beginUndoGrouping()
        defer { context.undoManager?.endUndoGrouping() }
        
        guard let uuid = exercise.uuid else { return }
        context.undoManager?.registerUndo(
            withTarget: self,
            selector: #selector(undoExerciseDelete(_ :)),
            object: exercise
        )
        exerciseDataManager.removeExercise(with: uuid, in: context)
        reloadExercises()
    }
    
    //TODO: Fix. In rare cases the list freezes
    @objc func undoExerciseMove(_ exercise: ExerciseEntity) {
        context.undoManager?.beginUndoGrouping()
        defer { context.undoManager?.endUndoGrouping() }
        
        context.undoManager?.registerUndo(
            withTarget: self,
            selector: #selector(undoExerciseMove(_ :)),
            object: exercise
        )
        reloadExercises()
    }
    
    func beginExerciseEditing() {
        self.context.undoManager?.disableUndoRegistration()
    }
    
    //TODO: Fix undo-redo for exercises
    func endExerciseEditing(for exercise: ExerciseEntity, shouldSave: Bool) {
        defer { self.context.undoManager?.enableUndoRegistration() }
        
        if shouldSave,
            exercise.workout == nil,
            let fetchedExercise = exerciseDataManager.fetchExercise(exercise: exercise, in: self.context) {
//            mainContext.undoManager?.registerUndo(
//                withTarget: self,
//                selector: #selector(redoExerciseDelete(_ :)),
//                object: fetchedExercise
//            )
            workout.addToExercises(fetchedExercise)
        }
        
        reloadExercises()
    }
    
    func saveWorkout() {
        do {
            try context.save()
            parent.saveContext()
            parent.refreshData()
        } catch {
            print("\(type(of: self)): \(#function): Error saving workout context: \(error)")
        }
    }
    
    func discardWorkout() {
        context.rollback()
    }
    
    func reloadExercises() {
        do {
            exercises = try workoutDataManager
                .fetchExercises(for: self.workout, in: self.context)
                .get()
                .compactMap { $0.toExerciseRepresentation() }
        } catch {
            print("\(type(of: self)): \(#function): Error fetching exercises: \(error)")
        }
    }
    
    func undo() {
        context.undoManager?.undo()
        self.objectWillChange.send()
    }
    
    func redo() {
        context.undoManager?.redo()
        self.objectWillChange.send()
    }
}

extension WorkoutEditorModel: Undoable {}
