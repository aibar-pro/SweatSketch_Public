//
//  ExerciseEditorModel.swift
//  MyWorkoutPlanner
//
//  Created by aibaranchikov on 29.11.2023.
//

import CoreData

class ExerciseEditorModel: ObservableObject {

    private let parent: WorkoutEditorModel
    private let mainContext: NSManagedObjectContext
    
    @Published var exercise: ExerciseEntity
    @Published var actions = [ExerciseActionEntity]()
    @Published var editingAction: ExerciseActionEntity?
    @Published var restBetweenActions: RestActionEntity
    
    private let workoutDataManager = WorkoutDataManager()
    private let exerciseDataManager = ExerciseDataManager()
    
    init?(parent: WorkoutEditorModel, exerciseId: UUID? = nil) {
        self.parent = parent
        self.mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.mainContext.parent = parent.mainContext
        
        let undoMgr = UndoManager()
        undoMgr.levelsOfUndo = Constants.Data.undoLevelsLimit
        self.mainContext.undoManager = undoMgr
        undoMgr.beginUndoGrouping()
        
        self.exercise = ExerciseEntity()
        self.restBetweenActions = RestActionEntity()
        
        if let exerciseId,
            let exerciseToEdit = exerciseDataManager.fetchExercise(by: exerciseId, in: self.mainContext) {
            self.exercise = exerciseToEdit
            self.actions = exerciseDataManager.fetchActions(for: exerciseToEdit, in: self.mainContext)
            
            setupEditingActions()
        } else {
            guard case .success(let createdExercise) = workoutDataManager
                .createExercise(
                    for: self.parent.editingWorkout,
                    in: self.mainContext
                )
            else {
                return nil
            }
            
            self.exercise = createdExercise
            
//            addExerciseAction()
        }
        
        if let restTimeBetweenActions = exerciseDataManager.fetchRestTimeBetweenActions(for: self.exercise, in: self.mainContext) {
            self.restBetweenActions = restTimeBetweenActions
        } else {
            self.restBetweenActions = exerciseDataManager
                .createRestTimeBetweenActions(
                    for: self.exercise,
                    with: self.parent.defaultRestTime.duration.int,
                    in: self.mainContext
                )
        }
        
        undoMgr.endUndoGrouping()
        undoMgr.removeAllActions()
    }
    
    func addExerciseAction() {
        let newAction = exerciseDataManager.createAction(for: exercise, in: mainContext)
        actions.append(newAction)
        setEditingAction(newAction)
    }
    
    private func setupEditingActions() {
        //TODO: Fix
//        editingExerciseActions.forEach{
//            switch ExerciseType.from(rawValue: self.editingExercise.type) {
//            case .timed:
//                $0.name = ""
//                if $0.type == nil { $0.type = ExerciseActionType.timed.rawValue }
//                if $0.duration < 0 { $0.duration = Int32(Constants.DefaultValues.actionDuration) }
//            case .setsNreps:
//                $0.name = ""
//                fallthrough
//            case .mixed:
//                if $0.name == nil { $0.name = Constants.Placeholders.noActionName }
//                fallthrough
//            default:
//                if $0.type == nil { $0.type = ExerciseActionType.setsNreps.rawValue }
//                if $0.sets < 1 { $0.sets = Int16(Constants.DefaultValues.setsCount) }
//                if $0.reps < 1 { $0.reps = Int16(Constants.DefaultValues.repsCount) }
//            }
//        }
    }
    
    func updateDefaultRestTime(withDuration duration: Int) {
        self.restBetweenActions.duration = duration.int32
    }
    
    func renameExercise(newName: String) {
        self.exercise.name = newName
        self.objectWillChange.send()
    }
    
    func setSupersets(count: Int) {
        self.exercise.superSets = count.int16
        self.objectWillChange.send()
    }
    
    func setRestBetweenActions(duration: Int) {
        self.restBetweenActions.duration = duration.int32
        self.objectWillChange.send()
    }
    
    func setEditingExerciseType(to type: ExerciseType) {
        setupEditingActions()
//        editingExercise.type = type.rawValue
//        if type == .mixed {
//            if editingExercise.superSets < 1 {
//                setSupersets(count: Constants.DefaultValues.supersetCount)
//            }
//            setRestTimeBetweenActions(newDuration: 0)
//            editingExerciseActions.forEach({
//                $0.name = Constants.Placeholders.noActionName
//            })
//        } else {
//            editingExerciseActions.forEach({
//                $0.name = nil
//            })
//        }
        self.objectWillChange.send()
    }
    //TODO: Fix
    func setEditingActionType(to type: ExerciseActionType) {
//        self.editingAction?.type = type.rawValue
//        
//        switch ExerciseActionType.from(rawValue: self.editingAction?.type) {
//        case .timed:
//            if self.editingAction?.duration == nil {
//                self.editingAction?.duration = Int32(Constants.DefaultValues.actionDuration)
//            }
//        default:
//            if let sets = self.editingAction?.sets, sets < 1 {
//                self.editingAction?.sets = Int16(Constants.DefaultValues.setsCount)
//            }
//            if let reps = self.editingAction?.reps, reps < 1 {
//                self.editingAction?.reps = Int16(Constants.DefaultValues.repsCount)
//            }
//        }
//        self.objectWillChange.send()
    }
    //TODO: Fix
    func saveFilteredExerciseActions() {
//        let filteredActions = editingExerciseActions.filter { action in
//            switch ExerciseType.from(rawValue: editingExercise.type) {
//                case .setsNreps:
//                    return ExerciseActionType.from(rawValue: action.type) == .setsNreps
//                case .timed:
//                    return ExerciseActionType.from(rawValue: action.type) == .timed
//                case .mixed:
//                    return [.setsNreps, .timed].contains(ExerciseActionType.from(rawValue: action.type))
//                case .unknown:
//                    return ExerciseActionType.from(rawValue: action.type) == .unknown
//            }
//        }
//        
//        let originalSet = Set(editingExerciseActions)
//        let filteredSet = Set(filteredActions)
//        let itemsToDelete = originalSet.subtracting(filteredSet)
//        
//        editingExerciseActions.removeAll { item in
//            itemsToDelete.contains(item)
//        }
//        
//        itemsToDelete.forEach{ item in
//            self.mainContext.delete(item)
//        }
    }
    
    func deleteExerciseActions(at offsets: IndexSet) {
        let actionsToDelete = offsets.map { self.actions[$0] }
        actionsToDelete.forEach { exerciseAction in
            self.actions.remove(atOffsets: offsets)
            self.mainContext.delete(exerciseAction)
        }
    }
    
    func moveExerciseActions(from source: IndexSet, to destination: Int) {
        actions.move(fromOffsets: source, toOffset: destination)
        
        actions.enumerated().forEach{ index, exerciseAction in
            exercise.removeFromExerciseActions(exerciseAction)
            exercise.insertIntoExerciseActions(exerciseAction, at: index)
            exerciseAction.position = index.int16
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
    
//    func saveExercise() {
//        saveFilteredExerciseActions()
//        do {
//            try mainContext.save()
//            parent.endExerciseEditing(for: editingExercise, shouldSave: true)
//        } catch {
//            print("Error saving exercise temporary context: \(error)")
//        }
//    }
//    
//    func discardExercise() {
//        mainContext.rollback()
//    }
//
    func commit(saveChanges: Bool) {
        if saveChanges {
            do {
                try mainContext.save()
                parent.endExerciseEditing(for: exercise, shouldSave: true)
            } catch {
                assertionFailure("Exercise save error: \(error)")
            }
        } else {
            mainContext.rollback()
            parent.endExerciseEditing(for: exercise, shouldSave: false)
        }
    }
}

extension ExerciseEditorModel: Undoable {
    var canUndo: Bool {
        mainContext.undoManager?.canUndo ?? false
    }
    var canRedo: Bool {
        mainContext.undoManager?.canRedo ?? false
    }

    func undo() {
        mainContext.undo()
        objectWillChange.send()
    }
    
    func redo() {
        mainContext.redo()
        objectWillChange.send()
    }
}
