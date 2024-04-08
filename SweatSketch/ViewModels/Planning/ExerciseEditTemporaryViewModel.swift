//
//  ExerciseViewModel.swift
//  MyWorkoutPlanner
//
//  Created by aibaranchikov on 29.11.2023.
//

import Foundation
import CoreData

class ExerciseEditTemporaryViewModel: ObservableObject {

    private let parentViewModel: WorkoutEditTemporaryViewModel
    private let mainContext: NSManagedObjectContext
    
    @Published var editingExercise: ExerciseEntity
    @Published var exerciseActions: [ExerciseActionEntity] = []
    @Published var editingAction: ExerciseActionEntity?
    @Published var restTimeBetweenActions: ExerciseActionEntity
    
    private var isNewExercise: Bool = false
    
    private let workoutDataManager = WorkoutDataManager()
    private let exerciseDataManager = ExerciseDataManager()
    
    init(parentViewModel: WorkoutEditTemporaryViewModel, editingExercise: ExerciseEntity? = nil) {
        self.parentViewModel = parentViewModel
        self.mainContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        self.mainContext.parent = parentViewModel.mainContext
        
        self.editingExercise = ExerciseEntity()
        self.restTimeBetweenActions = ExerciseActionEntity()
        
        if let exercise = editingExercise, let exerciseToEdit = exerciseDataManager.fetchExercise(exercise: exercise, in: self.mainContext) {
            
            self.editingExercise = exerciseToEdit
            
            self.exerciseActions = exerciseDataManager.fetchActions(for: exerciseToEdit, in: self.mainContext)
            
            //TODO: Extract to method
            self.exerciseActions.forEach{
                switch ExerciseType.from(rawValue: self.editingExercise.type) {
                case .timed:
                    if $0.type == nil { $0.type = ExerciseActionType.timed.rawValue }
                    if $0.duration < 1 { $0.duration = Int32(1) }
                case .setsNreps:
                    if $0.type == nil { $0.type = ExerciseActionType.setsNreps.rawValue }
                    if $0.sets < 1 { $0.sets = Int16(1) }
                    if $0.reps < 1 { $0.reps = Int16(1) }
                default: break
                }
            }
        } else {
            self.isNewExercise = true
            self.editingExercise = exerciseDataManager.createDefaultExercise(position: Int16(parentViewModel.exercises.count), in: self.mainContext)
        }
        
        if let restTimeBetweenActions = exerciseDataManager.fetchRestTimeBetweenActions(for: self.editingExercise, in: self.mainContext) {
            self.restTimeBetweenActions = restTimeBetweenActions
        } else {
            self.restTimeBetweenActions = exerciseDataManager.createDefaultRestTimeBetweenActions(for: Int(parentViewModel.defaultRestTime.duration), in: self.mainContext)
            self.editingExercise.addToExerciseActions(self.restTimeBetweenActions)
        }
    }
    
    func addExerciseAction() {
        let newExerciseAction = ExerciseActionEntity(context: mainContext)
        newExerciseAction.uuid = UUID()
        newExerciseAction.name = Constants.Design.Placeholders.noActionName
        newExerciseAction.order = Int16(editingExercise.exerciseActions?.count ?? 0)
        
        switch ExerciseType.from(rawValue: self.editingExercise.type) {
        case .timed:
            newExerciseAction.type = ExerciseActionType.timed.rawValue
            newExerciseAction.duration = 1
        default:
            newExerciseAction.type = ExerciseActionType.setsNreps.rawValue
            newExerciseAction.sets = 1
            newExerciseAction.reps = 1
        }
        
        editingExercise.addToExerciseActions(newExerciseAction)
        exerciseActions.append(newExerciseAction)
        setEditingAction(newExerciseAction)
    }
    
    
    func updateDefaultRestTime(withDuration duration: Int) {
        self.restTimeBetweenActions.duration = Int32(duration)
    }
    
    func renameExercise(newName: String) {
        self.editingExercise.name = newName
        self.objectWillChange.send()
    }
    
    func setSupersets(superset: Int) {
        self.editingExercise.superSets = Int16(superset)
        self.objectWillChange.send()
    }
    
    func setEditingExerciseType(to type: ExerciseType) {
        exerciseActions.forEach{ action in
            let actionType = ExerciseActionType.from(rawValue: action.type).rawValue
            if actionType.isEmpty || actionType == ExerciseActionType.unknown.rawValue {
                switch ExerciseType.from(rawValue: self.editingExercise.type) {
                case .timed:
                    action.type = ExerciseActionType.timed.rawValue
                    if action.duration < 1 { action.duration = Int32(1) }
                case .setsNreps:
                    action.type = ExerciseActionType.setsNreps.rawValue
                    if action.sets < 1 { action.sets = Int16(1) }
                    if action.reps < 1 { action.reps = Int16(1) }
                default: break
                }
            }
        }
        self.editingExercise.type = type.rawValue
        self.objectWillChange.send()
    }
    
    func setEditingActionType(to type: ExerciseActionType) {
        self.editingAction?.type = type.rawValue
        
        switch ExerciseActionType.from(rawValue: self.editingAction?.type) {
        case .timed:
            if self.editingAction!.duration < 1 { self.editingAction?.duration = Int32(1) }
        default:
            if self.editingAction!.sets < 1 { self.editingAction?.sets = Int16(1) }
            if self.editingAction!.reps < 1 { self.editingAction?.reps = Int16(1) }
        }
        self.objectWillChange.send()
    }
    
    func saveFilteredExerciseActions() {
        let filteredActions = exerciseActions.filter { action in
            switch ExerciseType.from(rawValue: editingExercise.type) {
                case .setsNreps:
                    return ExerciseActionType.from(rawValue: action.type) == .setsNreps
                case .timed:
                    return ExerciseActionType.from(rawValue: action.type) == .timed
                case .mixed:
                    return ExerciseActionType.from(rawValue: action.type) == .setsNreps || ExerciseActionType.from(rawValue: action.type) == .timed
                case .unknown:
                    return ExerciseActionType.from(rawValue: action.type) == .unknown
            }
        }
        
        let originalSet = Set(exerciseActions)
        let filteredSet = Set(filteredActions)
        let itemsToDelete = originalSet.subtracting(filteredSet)
        
        exerciseActions.removeAll { item in
            itemsToDelete.contains(item)
        }
        
        itemsToDelete.forEach{ item in
            self.mainContext.delete(item)
        }
    }
    
    func deleteExerciseActions(at offsets: IndexSet) {
        let actionsToDelete = offsets.map { self.exerciseActions[$0] }
        actionsToDelete.forEach { exerciseAction in
            self.exerciseActions.remove(atOffsets: offsets)
            self.mainContext.delete(exerciseAction)
        }
    }
    
    func moveExerciseActions(from source: IndexSet, to destination: Int) {
        exerciseActions.move(fromOffsets: source, toOffset: destination)
        
        exerciseActions.enumerated().forEach{ index, exerciseAction in
            editingExercise.removeFromExerciseActions(exerciseAction)
            editingExercise.insertIntoExerciseActions(exerciseAction, at: index)
            exerciseAction.order=Int16(index)
        }
    }
    
    func setEditingAction(_ action: ExerciseActionEntity) {
        editingAction = action
    }

    func clearEditingAction() {
        editingAction = nil
    }
    
    func isEditingAction(_ action: ExerciseActionEntity) -> Bool {
        editingAction == action
    }
    
    func saveExercise() {
        saveFilteredExerciseActions()
        do {
            if editingExercise.workout == nil, let workoutToUpdate = workoutDataManager.fetchWorkout(workout: parentViewModel.editingWorkout, in: self.mainContext) {
                editingExercise.workout = workoutToUpdate
            }
            try mainContext.save()
            parentViewModel.refreshData()
        } catch {
            print("Error saving exercise temporary context: \(error)")
        }
    }
    
    func discardExercise() {
        
    }
    
}
