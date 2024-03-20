//
//  ExerciseViewModel.swift
//  MyWorkoutPlanner
//
//  Created by aibaranchikov on 29.11.2023.
//

import Foundation
import CoreData

class ExerciseEditTemporaryViewModel: ObservableObject {
    private let temporaryContext: NSManagedObjectContext
    private let parentViewModel: WorkoutEditTemporaryViewModel
    
    @Published var editingExercise: ExerciseEntity?
    @Published var exerciseActions: [ExerciseActionEntity] = []
    
    init(parentViewModel: WorkoutEditTemporaryViewModel, editingExercise: ExerciseEntity? = nil) {
        self.temporaryContext = parentViewModel.temporaryContext
        self.temporaryContext.undoManager?.beginUndoGrouping()
        
        self.parentViewModel = parentViewModel
        
        if editingExercise != nil {
            self.editingExercise = editingExercise
            self.exerciseActions = editingExercise?.exerciseActions?.array as? [ExerciseActionEntity] ?? []
        } else {
            addExercise(name: "New exercise")
        }
    }
    
    func addExercise(name: String) {
        let newExercise = ExerciseEntity(context: temporaryContext)
        newExercise.uuid = UUID()
        newExercise.name = name
        newExercise.order = (parentViewModel.exercises.last?.order ?? -1) + 1
        newExercise.type = ExerciseType.setsNreps.rawValue
        self.editingExercise = newExercise
    }
    
    func renameExercise(newName: String) {
        self.editingExercise?.name = newName
    }
    
    func setSupersets(superset: Int) {
        self.editingExercise?.superSets = Int16(superset)
    }
    
    func setExerciseType(type: ExerciseType) {
        exerciseActions.forEach{ action in
            let actionType = ExerciseActionType.from(rawValue: action.type).rawValue
            if actionType.isEmpty || actionType == ExerciseActionType.unknown.rawValue {
                let exerciseType = ExerciseType.from(rawValue: self.editingExercise?.type)
                switch exerciseType {
                case .setsNreps:
                    action.type = ExerciseActionType.setsNreps.rawValue
                    print("Action type changed to SNR")
                case .timed:
                    action.type = ExerciseActionType.timed.rawValue
                    print("Action type changed to timed")
                case .mixed, .unknown:
                    action.type = ExerciseActionType.unknown.rawValue
                }
            }
        }
        self.editingExercise?.type = type.rawValue
    }
    
    func addFilteredExerciseActions() {
        let filteredActions = exerciseActions.filter { action in
            if let exerciseTypeToFilter = editingExercise?.type {
                switch ExerciseType.from(rawValue: exerciseTypeToFilter) {
                case .setsNreps:
                    return ExerciseActionType.from(rawValue: action.type) == .setsNreps
                case .timed:
                    return ExerciseActionType.from(rawValue: action.type) == .timed
                case .mixed:
                    return ExerciseActionType.from(rawValue: action.type) == .setsNreps || ExerciseActionType.from(rawValue: action.type) == .timed
                case .unknown:
                    return ExerciseActionType.from(rawValue: action.type) == .unknown
                }
            } else {
                return ExerciseActionType.from(rawValue: action.type) == .setsNreps || ExerciseActionType.from(rawValue: action.type) == .timed || ExerciseActionType.from(rawValue: action.type) == .unknown
            }
        }
        
        let originalSet = Set(exerciseActions)
        let filteredSet = Set(filteredActions)
        let itemsToDelete = originalSet.subtracting(filteredSet)
        
        exerciseActions.removeAll { item in
            itemsToDelete.contains(item)
        }
        
        itemsToDelete.forEach{ item in
            temporaryContext.delete(item)
        }
    }
    
    func deleteExerciseActions(at offsets: IndexSet) {
        let actionsToDelete = offsets.map { self.exerciseActions[$0] }
        actionsToDelete.forEach { exerciseAction in
            self.exerciseActions.remove(atOffsets: offsets)
            self.temporaryContext.delete(exerciseAction)
        }
    }
    
    func reorderWorkoutExerciseActions(from source: IndexSet, to destination: Int) {
        exerciseActions.move(fromOffsets: source, toOffset: destination)
        
        exerciseActions.enumerated().forEach{ index, exerciseAction in
            editingExercise?.removeFromExerciseActions(exerciseAction)
            editingExercise?.insertIntoExerciseActions(exerciseAction, at: index)
            exerciseAction.order=Int16(index)
        }
    }
    
    func saveExercise() {
        if let exerciseToAdd = self.editingExercise {
            parentViewModel.addWorkoutExercise(newExercise: exerciseToAdd)
            self.temporaryContext.undoManager?.endUndoGrouping()
        }
        
    }
    
    func discardExercise() {
//        temporaryContext.rollback()
    }
    
}
