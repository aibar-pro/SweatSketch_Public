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
    
    func goToAdvancedEditRestPeriod() {
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

