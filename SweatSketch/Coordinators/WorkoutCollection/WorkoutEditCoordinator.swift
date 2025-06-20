//
//  WorkoutEditCoordinators.swift
//  SweatSketch
//
//  Created by aibaranchikov on 15.03.2024.
//

import SwiftUI

class WorkoutEditCoordinator: BaseCoordinator<WorkoutEditViewModel>, Coordinator {
    func start() {
        let view = WorkoutEditView(viewModel: self.viewModel).environmentObject(self)
        rootViewController = UIHostingController(rootView: view)
        rootViewController.view.backgroundColor = .clear
    }
    
    func goToAddExercise() {
        guard let exerciseEditViewModel = ExerciseEditViewModel(parentViewModel: viewModel, editingExercise: nil)
        else {
            print("\(type(of: self)): \(#function): Failed to initialize ExerciseEditViewModel")
            return
        }
        
        presentExerciseEditViewController(using: exerciseEditViewModel)
    }
    
    func goToEditExercise(exerciseToEdit: ExerciseEntity) {
        guard let exerciseEditViewModel = ExerciseEditViewModel(parentViewModel: viewModel, editingExercise: exerciseToEdit)
        else {
            print("\(type(of: self)): \(#function): Failed to initialize ExerciseEditViewModel")
            return
        }
        
        presentExerciseEditViewController(using: exerciseEditViewModel)
    }
    
    private func presentExerciseEditViewController(using viewModel: ExerciseEditViewModel) {
        let exerciseEditCoordinator = ExerciseEditCoordinator(viewModel: viewModel)
        
        exerciseEditCoordinator.start()
        childCoordinators.append(exerciseEditCoordinator)
        
        let editExerciseViewController = exerciseEditCoordinator.rootViewController
        editExerciseViewController.modalPresentationStyle = .formSheet
        rootViewController.present(editExerciseViewController, animated: true)
    }
    
    func goToAdvancedEditRestPeriod() {
        guard let restTimeEditViewModel = RestTimeEditViewModel(parentViewModel: viewModel) else {
            print("\(type(of: self)): \(#function): Failed to initialize RestTimeEditViewModel")
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

