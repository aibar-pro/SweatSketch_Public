//
//  WorkoutEditCoordinators.swift
//  SweatSketch
//
//  Created by aibaranchikov on 15.03.2024.
//

import SwiftUI

class WorkoutEditorCoordinator: BaseCoordinator<WorkoutEditorModel>, Coordinator {
    @Published private(set) var activeUndoTarget: Undoable?
    private(set) var exerciseEditorModel: ExerciseEditorModel?
    
    override init(viewModel: WorkoutEditorModel) {
        super.init(viewModel: viewModel)
        self.activeUndoTarget = viewModel
    }
    
    func start() {
        let view = WorkoutEditorView(viewModel: self.viewModel).environmentObject(self)
        rootViewController = UIHostingController(rootView: view)
        rootViewController.view.backgroundColor = .clear
    }
    
    func beginExerciseEditing(uuid: UUID? = nil) {
        guard let eeModel = ExerciseEditorModel(parent: viewModel, exerciseId: uuid)
        else {
            assertionFailure("Failed to create \(type(of: ExerciseEditorModel.self))")
            return
        }
        
        exerciseEditorModel = eeModel
        activeUndoTarget = eeModel
        viewModel.beginExerciseEditing()
    }
    
    func endExerciseEditing(shouldCommit: Bool) {
        guard let editorModel = self.exerciseEditorModel else {
            assertionFailure("No exercise editor model to commit")
            return
        }
        
        editorModel.commit(saveChanges: shouldCommit)
        
        exerciseEditorModel = nil
        activeUndoTarget = viewModel
    }
    
    func goToAdvancedRestSettings() {
        guard let restTimeEditViewModel = RestTimeEditViewModel(parentViewModel: viewModel) else {
            assertionFailure("Failed to create \(type(of: RestTimeEditViewModel.self))")
            return
        }
        let restTimeCoordinator = RestTimeEditCoordinator(viewModel: restTimeEditViewModel)
        
        restTimeCoordinator.start()
        childCoordinators.append(restTimeCoordinator)
        
        let restTimeViewController = restTimeCoordinator.rootViewController
        restTimeViewController.modalPresentationStyle = .formSheet
        rootViewController.present(restTimeViewController, animated: true)
    }
    
    func presentExerciseRenameSheet(
        onSubmit: @escaping (String) -> Void,
        onDismiss: @escaping () -> Void
    ) {
        presentBottomSheet(
            type: .singleTextField(
                kind: .exerciseRename,
                initialText: exerciseEditorModel?.exercise.name ?? "",
                action: onSubmit,
                cancel: onDismiss
            )
        )
    }
    
    func presentExerciseRestSheet(
        onSubmit: @escaping (Int) -> Void,
        onDismiss: @escaping () -> Void
    ) {
        presentBottomSheet(
            type: .timePicker(
                kind: .exercise,
                initialValue: exerciseEditorModel?.restBetweenActions.duration.int ?? 0,
                action: onSubmit,
                cancel: onDismiss
            )
        )
    }
    
    func presentExerciseActionSheet(
        for actionDraft: ActionDraftModel,
        onSubmit: @escaping (ActionDraftModel) -> Void,
        onDismiss: @escaping () -> Void
    ) {
        presentBottomSheet(
            type: .actionEditor(
                for: actionDraft,
                action: onSubmit,
                cancel: onDismiss
            )
        )
    }

    func presentExerciseRepetitionsSheet(
        onSubmit: @escaping (Int) -> Void,
        onDismiss: @escaping () -> Void
    ) {
        presentBottomSheet(
            type: .singleTextField(
                kind: .exerciseSetCount,
                initialText: String(exerciseEditorModel?.exercise.superSets ?? 1),
                action: {
                    let intValue = min(1, Int($0) ?? 1)
                    onSubmit(intValue)
                },
                cancel: onDismiss
            )
        )
    }
    
    func saveWorkoutEdit(){
        print("\(type(of: self)): Save workout, \(Date())")
        viewModel.saveWorkout()
        addViewPushTransition(pushDirection: .fromTop)
        rootViewController.navigationController?.popViewController(animated: false)
    }
    
    func discardWorkoutEdit(){
        print("\(type(of: self)): Discard workout, \(Date())")
        viewModel.discardWorkout()
        addViewPushTransition(pushDirection: .fromTop)
        rootViewController.navigationController?.popViewController(animated: false)
    }
}

