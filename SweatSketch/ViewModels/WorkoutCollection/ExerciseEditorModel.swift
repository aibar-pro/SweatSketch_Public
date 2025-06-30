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
    @Published var actionDraft: ActionDraftModel?
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
            reloadActions()
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
        }
        
        if let restTimeBetweenActions = exerciseDataManager.fetchRestTimeBetweenActions(for: self.exercise, in: self.mainContext) {
            self.restBetweenActions = restTimeBetweenActions
        } else {
            self.restBetweenActions = exerciseDataManager
                .createRestBetweenActions(
                    for: self.exercise,
                    with: self.parent.defaultRestTime.duration.int,
                    in: self.mainContext
                )
        }
        
        undoMgr.endUndoGrouping()
        undoMgr.removeAllActions()
    }
    
    @MainActor
    func prepareActionForEditing(_ id: UUID? = nil) {
        actionDraft = {
            guard let id,
                    let actionToEdit = actions.first(where: { $0.uuid == id })
            else {
                return ActionDraftModel(
                    position: exerciseDataManager
                        .calculateNewActionPosition(for: exercise, in: self.mainContext)
                        .int
                )
            }
            
            return ActionDraftModel(from: actionToEdit, lengthSystem: AppSettings.shared.lengthSystem)
        }()
    }
    
    func commitActionDraft(_ draft: ActionDraftModel) {
        self.mainContext.undoManager?.beginUndoGrouping()
        
        if let actionUUID = draft.entityUUID {
            if draft.kind == draft.entityKind {
                updateAction(from: draft)
                print("\(type(of: self)): \(#function): Action updated")
            } else {
                exerciseDataManager.removeAction(with: actionUUID, from: exercise, in: self.mainContext)
                createAction(from: draft)
                print("\(type(of: self)): \(#function): Action kind changed, action removed and recreated")
            }
        } else {
            createAction(from: draft)
            print("\(type(of: self)): \(#function): Action created")
        }

        self.mainContext.undoManager?.endUndoGrouping()
        
        reloadActions()
    }
    
    private func createAction(from draft: ActionDraftModel) {
        switch draft.kind {
        case .reps:
            _ = exerciseDataManager.createRepsAction(for: exercise, from: draft, in: self.mainContext)
        case .timed:
            _ = exerciseDataManager.createTimedAction(for: exercise, from: draft, in: self.mainContext)
        case .distance:
            _ = exerciseDataManager.createDistanceAction(for: exercise, from: draft, in: self.mainContext)
        default: break
        }
    }
    
    private func updateAction(from draft: ActionDraftModel) {
        guard let entityUUID = draft.entityUUID else { return }
        
        switch draft.kind {
        case .reps:
            _ = exerciseDataManager.updateRepsAction(with: entityUUID, using: draft, in: self.mainContext)
        case .timed:
            _ = exerciseDataManager.updateTimedAction(with: entityUUID, using: draft, in: self.mainContext)
        case .distance:
            _ = exerciseDataManager.updateDistanceAction(with: entityUUID, using: draft, in: self.mainContext)
        default: break
        }
    }
    
    func reloadActions() {
//        do {
        actions = exerciseDataManager.fetchActions(for: exercise, in: self.mainContext)
//        } catch {
//            print("\(type(of: self)): \(#function): Error fetching exercises: \(error)")
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
