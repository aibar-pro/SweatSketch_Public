//
//  ExerciseEditorModel.swift
//  MyWorkoutPlanner
//
//  Created by aibaranchikov on 29.11.2023.
//

import CoreData

class ExerciseEditorModel: ObservableObject {

    private let parent: WorkoutEditorModel
    private let context: NSManagedObjectContext
    
    @Published var exercise: ExerciseEntity
    @Published var actions: [ActionRepresentation] = []
    @Published var actionDraft: ActionDraftModel?
    @Published var restBetweenActions: Int
    
    private let workoutDataManager = WorkoutDataManager()
    private let exerciseDataManager = ExerciseDataManager()
    
    init?(parent: WorkoutEditorModel, exerciseId: UUID? = nil) {
        self.context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.context.parent = parent.context
        self.parent = parent
        
        if self.context.undoManager == nil {
            self.context.undoManager = UndoManager()
        }
        self.context.undoManager?.levelsOfUndo = Constants.Data.undoLevelsLimit
        self.context.undoManager?.disableUndoRegistration()
        
        self.exercise = ExerciseEntity()

        if let exerciseId,
            let exerciseToEdit = exerciseDataManager.fetchExercise(by: exerciseId, in: self.context) {
            self.exercise = exerciseToEdit
            
            if let rest = exerciseToEdit.intraRest {
                self.restBetweenActions = rest.intValue
            } else {
                self.restBetweenActions = self.parent.defaultRestTime
            }
            
            reloadActions()
        } else {
            let defaultRestTime = parent.defaultRestTime
            
            guard case .success(let createdExercise) = workoutDataManager
                .createExercise(
                    for: self.parent.workout,
                    intraRest: defaultRestTime,
                    in: self.context
                )
            else {
                return nil
            }
            
            self.exercise = createdExercise
            self.restBetweenActions = defaultRestTime
        }
        
        self.context.undoManager?.enableUndoRegistration()
    }
    
    @MainActor
    func prepareActionForEditing(_ uuid: UUID? = nil) {
        actionDraft = {
            guard let uuid,
                  let actionToEdit = try? exerciseDataManager.fetchAction(with: uuid, in: self.context).get()
            else {
                return ActionDraftModel(
                    position: exerciseDataManager
                        .calculateNewActionPosition(for: exercise, in: self.context)
                        .int
                )
            }
            
            return ActionDraftModel(from: actionToEdit, lengthSystem: AppSettings.shared.lengthSystem)
        }()
    }
    
    func commitActionDraft(_ draft: ActionDraftModel) {
        context.undoManager?.beginUndoGrouping()
        defer { context.undoManager?.endUndoGrouping() }
        
        if let actionUUID = draft.entityUUID {
            if draft.kind == draft.entityKind {
                updateAction(from: draft)
                print("\(type(of: self)): \(#function): Action updated")
            } else {
                exerciseDataManager.removeAction(with: actionUUID, in: self.context)
                createAction(from: draft)
                print("\(type(of: self)): \(#function): Action kind changed, action removed and recreated")
            }
        } else {
            createAction(from: draft)
            print("\(type(of: self)): \(#function): Action created")
        }

        reloadActions()
    }
    
    private func createAction(from draft: ActionDraftModel) {
        switch draft.kind {
        case .reps:
            _ = exerciseDataManager.createRepsAction(for: exercise, from: draft, in: self.context)
        case .timed:
            _ = exerciseDataManager.createTimedAction(for: exercise, from: draft, in: self.context)
        case .distance:
            _ = exerciseDataManager.createDistanceAction(for: exercise, from: draft, in: self.context)
        default: break
        }
    }
    
    private func updateAction(from draft: ActionDraftModel) {
        guard let entityUUID = draft.entityUUID else { return }
        
        switch draft.kind {
        case .reps:
            _ = exerciseDataManager.updateRepsAction(with: entityUUID, using: draft, in: self.context)
        case .timed:
            _ = exerciseDataManager.updateTimedAction(with: entityUUID, using: draft, in: self.context)
        case .distance:
            _ = exerciseDataManager.updateDistanceAction(with: entityUUID, using: draft, in: self.context)
        default: break
        }
    }
    
    func reloadActions() {
        actions = exerciseDataManager
            .fetchActions(for: exercise, in: self.context)
            .compactMap {
                $0.toActionViewRepresentation(exerciseName: exercise.name)
            }
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
        guard duration >= 0,
                duration != parent.workout.defaultRest else { return }
        restBetweenActions = duration
        exercise.intraRest = duration.nsNumber
    }
    
    func deleteActions(at offsets: IndexSet) {
        let toDelete = offsets.map { actions[$0].entityUUID }
        toDelete.forEach { exerciseDataManager.removeAction(with: $0, in: context) }
        
        actions.remove(atOffsets: offsets)
    }
    
    func moveActions(from source: IndexSet, to destination: Int) {
        actions.move(fromOffsets: source, toOffset: destination)
        
        context.undoManager?.beginUndoGrouping()
        defer { context.undoManager?.endUndoGrouping() }
        
        let positions = Dictionary(
            uniqueKeysWithValues: actions.enumerated().map { idx, repr in
                (repr.entityUUID, idx + 1)
            }
        )
        exerciseDataManager.updateActionPositions(positions, for: exercise, in: context)
    }
    
    func commit(saveChanges: Bool) {
        if saveChanges {
            do {
                try context.save()
                parent.endExerciseEditing(for: exercise, shouldSave: true)
            } catch {
                assertionFailure("Exercise save error: \(error)")
            }
        } else {
            context.rollback()
            parent.endExerciseEditing(for: exercise, shouldSave: false)
        }
    }
}

extension ExerciseEditorModel: Undoable {
    var canUndo: Bool {
        context.undoManager?.canUndo ?? false
    }
    var canRedo: Bool {
        context.undoManager?.canRedo ?? false
    }

    func undo() {
        context.undo()
        objectWillChange.send()
    }
    
    func redo() {
        context.redo()
        objectWillChange.send()
    }
}
