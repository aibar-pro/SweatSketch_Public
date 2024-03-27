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
    let temporaryExerciseContext: NSManagedObjectContext
    
    @Published var editingExercise: ExerciseEntity?
    @Published var exerciseActions: [ExerciseActionEntity] = []
    @Published var editingAction: ExerciseActionEntity?
    var isEditingAction: Bool {
        self.editingAction != nil
    }
    
    private var isNewExercise: Bool = false
    
    init(parentViewModel: WorkoutEditTemporaryViewModel, editingExercise: ExerciseEntity? = nil) {
        self.parentViewModel = parentViewModel
        self.temporaryExerciseContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        self.temporaryExerciseContext.parent = parentViewModel.temporaryWorkoutContext
        
        if editingExercise != nil {
            let exerciseFetchRequest: NSFetchRequest<ExerciseEntity> = ExerciseEntity.fetchRequest()
            exerciseFetchRequest.predicate = NSPredicate(format: "SELF == %@", editingExercise!.objectID)
            do {
                self.editingExercise = try self.temporaryExerciseContext.fetch(exerciseFetchRequest).first
            } catch {
                print("Error fetching exercise for temporary context: \(error)")
            }
            self.exerciseActions = self.editingExercise?.exerciseActions?.array as? [ExerciseActionEntity] ?? []
            
            self.exerciseActions.forEach{
                switch ExerciseType.from(rawValue: self.editingExercise?.type) {
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
            addExercise()
        }
    }
    
    func addExercise() {
        let newExercise = ExerciseEntity(context: temporaryExerciseContext)
        newExercise.uuid = UUID()
        newExercise.name = Constants.Design.Placeholders.noExerciseName
        newExercise.order = (parentViewModel.exercises.last?.order ?? -1) + 1
        newExercise.type = ExerciseType.setsNreps.rawValue
        self.editingExercise = newExercise
        addExerciseAction()
    }
    
    func addExerciseAction() {
        let newExerciseAction = ExerciseActionEntity(context: temporaryExerciseContext)
        newExerciseAction.uuid = UUID()
        newExerciseAction.name = Constants.Design.Placeholders.noActionName
        newExerciseAction.order = Int16(editingExercise?.exerciseActions?.count ?? 0)
        
        switch ExerciseType.from(rawValue: self.editingExercise?.type) {
        case .timed:
            newExerciseAction.type = ExerciseActionType.timed.rawValue
            newExerciseAction.duration = 1
        default:
            newExerciseAction.type = ExerciseActionType.setsNreps.rawValue
            newExerciseAction.sets = 1
            newExerciseAction.reps = 1
        }
        
        editingExercise?.addToExerciseActions(newExerciseAction)
        exerciseActions.append(newExerciseAction)
        setEditingAction(newExerciseAction)
    }
    
    func renameExercise(newName: String) {
        self.editingExercise?.name = newName
        self.objectWillChange.send()
    }
    
    func setSupersets(superset: Int) {
        self.editingExercise?.superSets = Int16(superset)
        self.objectWillChange.send()
    }
    
    func setEditingExerciseType(to type: ExerciseType) {
        exerciseActions.forEach{ action in
            let actionType = ExerciseActionType.from(rawValue: action.type).rawValue
            if actionType.isEmpty || actionType == ExerciseActionType.unknown.rawValue {
                switch ExerciseType.from(rawValue: self.editingExercise?.type) {
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
        self.editingExercise?.type = type.rawValue
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
            switch ExerciseType.from(rawValue: editingExercise?.type) {
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
            self.temporaryExerciseContext.delete(item)
        }
    }
    
    func deleteExerciseActions(at offsets: IndexSet) {
        let actionsToDelete = offsets.map { self.exerciseActions[$0] }
        actionsToDelete.forEach { exerciseAction in
            self.exerciseActions.remove(atOffsets: offsets)
            self.temporaryExerciseContext.delete(exerciseAction)
        }
    }
    
    func moveExerciseActions(from source: IndexSet, to destination: Int) {
        exerciseActions.move(fromOffsets: source, toOffset: destination)
        
        exerciseActions.enumerated().forEach{ index, exerciseAction in
            editingExercise?.removeFromExerciseActions(exerciseAction)
            editingExercise?.insertIntoExerciseActions(exerciseAction, at: index)
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
        do {
            try temporaryExerciseContext.save()
            if let exerciseToAdd = self.editingExercise, isNewExercise {
                parentViewModel.addExercise(newExercise: exerciseToAdd)
            }
            parentViewModel.objectWillChange.send()
        } catch {
            print("Error saving exercise temporary context: \(error)")
        }
    }
    
    func discardExercise() {
        if let exerciseToDiscard = self.editingExercise, isNewExercise {
                temporaryExerciseContext.delete(exerciseToDiscard)
        }
    }
    
}
