//
//  ExerciseViewModel.swift
//  MyWorkoutPlanner
//
//  Created by aibaranchikov on 29.11.2023.
//

import CoreData

class ExerciseEditViewModel: ObservableObject {

    private let parentViewModel: WorkoutEditViewModel
    private let mainContext: NSManagedObjectContext
    
    @Published var editingExercise: ExerciseEntity
    @Published var editingExerciseActions = [ExerciseActionEntity]()
    @Published var editingAction: ExerciseActionEntity?
    @Published var restTimeBetweenActions: ExerciseActionEntity
    
    private let workoutDataManager = WorkoutDataManager()
    private let exerciseDataManager = ExerciseDataManager()
    
    init(parentViewModel: WorkoutEditViewModel, editingExercise: ExerciseEntity? = nil) {
        self.parentViewModel = parentViewModel
        self.mainContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        self.mainContext.parent = parentViewModel.mainContext
        
        self.editingExercise = ExerciseEntity()
        self.restTimeBetweenActions = ExerciseActionEntity()
        
        if let exercise = editingExercise, let exerciseToEdit = exerciseDataManager.fetchExercise(exercise: exercise, in: self.mainContext) {
            self.editingExercise = exerciseToEdit
            self.editingExerciseActions = exerciseDataManager.fetchActions(for: exerciseToEdit, in: self.mainContext)
            
            setupEditingActions()
        } else {
            self.editingExercise = workoutDataManager.createExercise(for: self.parentViewModel.editingWorkout, in: self.mainContext)
            
            addExerciseAction()
        }
        
        if let restTimeBetweenActions = exerciseDataManager.fetchRestTimeBetweenActions(for: self.editingExercise, in: self.mainContext) {
            self.restTimeBetweenActions = restTimeBetweenActions
        } else {
            self.restTimeBetweenActions = exerciseDataManager.createRestTimeBetweenActions(for: self.editingExercise, with: Int(self.parentViewModel.defaultRestTime.duration), in: self.mainContext)
        }
    }
    
    func addExerciseAction() {
        let newAction = exerciseDataManager.createAction(for: editingExercise, in: mainContext)
        editingExerciseActions.append(newAction)
        setEditingAction(newAction)
    }
    
    private func setupEditingActions() {
        editingExerciseActions.forEach{
            switch ExerciseType.from(rawValue: self.editingExercise.type) {
            case .timed:
                $0.name = ""
                if $0.type == nil { $0.type = ExerciseActionType.timed.rawValue }
                if $0.duration < 0 { $0.duration = Int32(Constants.DefaultValues.actionDuration) }
            case .setsNreps:
                $0.name = ""
                fallthrough
            case .mixed:
                if $0.name == nil { $0.name = Constants.Placeholders.noActionName }
                fallthrough
            default:
                if $0.type == nil { $0.type = ExerciseActionType.setsNreps.rawValue }
                if $0.sets < 1 { $0.sets = Int16(Constants.DefaultValues.setsCount) }
                if $0.reps < 1 { $0.reps = Int16(Constants.DefaultValues.repsCount) }
            }
        }
    }
    
    func updateDefaultRestTime(withDuration duration: Int) {
        self.restTimeBetweenActions.duration = Int32(duration)
    }
    
    func renameExercise(newName: String) {
        self.editingExercise.name = newName
        self.objectWillChange.send()
    }
    
    func setSupersets(count: Int) {
        self.editingExercise.superSets = Int16(count)
        self.objectWillChange.send()
    }
    
    func setRestTimeBetweenActions(newDuration: Int) {
        self.restTimeBetweenActions.duration = Int32(newDuration)
        self.objectWillChange.send()
    }
    
    func setEditingExerciseType(to type: ExerciseType) {
        setupEditingActions()
        editingExercise.type = type.rawValue
        if type == .mixed {
            if editingExercise.superSets < 1 {
                setSupersets(count: Constants.DefaultValues.supersetCount)
            }
            setRestTimeBetweenActions(newDuration: 0)
            editingExerciseActions.forEach({
                $0.name = Constants.Placeholders.noActionName
            })
        } else {
            editingExerciseActions.forEach({
                $0.name = nil
            })
        }
        self.objectWillChange.send()
    }
    
    func setEditingActionType(to type: ExerciseActionType) {
        self.editingAction?.type = type.rawValue
        
        switch ExerciseActionType.from(rawValue: self.editingAction?.type) {
        case .timed:
            if self.editingAction?.duration == nil {
                self.editingAction?.duration = Int32(Constants.DefaultValues.actionDuration)
            }
        default:
            if let sets = self.editingAction?.sets, sets < 1 {
                self.editingAction?.sets = Int16(Constants.DefaultValues.setsCount)
            }
            if let reps = self.editingAction?.reps, reps < 1 {
                self.editingAction?.reps = Int16(Constants.DefaultValues.repsCount)
            }
        }
        self.objectWillChange.send()
    }
    
    func saveFilteredExerciseActions() {
        let filteredActions = editingExerciseActions.filter { action in
            switch ExerciseType.from(rawValue: editingExercise.type) {
                case .setsNreps:
                    return ExerciseActionType.from(rawValue: action.type) == .setsNreps
                case .timed:
                    return ExerciseActionType.from(rawValue: action.type) == .timed
                case .mixed:
                    return [.setsNreps, .timed].contains(ExerciseActionType.from(rawValue: action.type))
                case .unknown:
                    return ExerciseActionType.from(rawValue: action.type) == .unknown
            }
        }
        
        let originalSet = Set(editingExerciseActions)
        let filteredSet = Set(filteredActions)
        let itemsToDelete = originalSet.subtracting(filteredSet)
        
        editingExerciseActions.removeAll { item in
            itemsToDelete.contains(item)
        }
        
        itemsToDelete.forEach{ item in
            self.mainContext.delete(item)
        }
    }
    
    func deleteExerciseActions(at offsets: IndexSet) {
        let actionsToDelete = offsets.map { self.editingExerciseActions[$0] }
        actionsToDelete.forEach { exerciseAction in
            self.editingExerciseActions.remove(atOffsets: offsets)
            self.mainContext.delete(exerciseAction)
        }
    }
    
    func moveExerciseActions(from source: IndexSet, to destination: Int) {
        editingExerciseActions.move(fromOffsets: source, toOffset: destination)
        
        editingExerciseActions.enumerated().forEach{ index, exerciseAction in
            editingExercise.removeFromExerciseActions(exerciseAction)
            editingExercise.insertIntoExerciseActions(exerciseAction, at: index)
            exerciseAction.position=Int16(index)
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
            try mainContext.save()
            if editingExercise.workout == nil {
                parentViewModel.addExerciseToWorkout(newExercise: editingExercise)
            }
            parentViewModel.refreshData()
        } catch {
            print("Error saving exercise temporary context: \(error)")
        }
    }
    
    func discardExercise() {
        mainContext.rollback()
    }
    
}
