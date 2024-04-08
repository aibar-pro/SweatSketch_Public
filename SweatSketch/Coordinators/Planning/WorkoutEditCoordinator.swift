//
//  WorkoutEditCoordinators.swift
//  SweatSketch
//
//  Created by aibaranchikov on 15.03.2024.
//

import SwiftUI

class WorkoutEditCoordinator: ObservableObject, Coordinator {
    
    var viewModel: WorkoutEditViewModel
    
    var rootViewController = UIViewController()
    var childCoordinators = [Coordinator]()
    
    init(viewModel: WorkoutEditViewModel) {
        rootViewController = UIViewController()
        self.viewModel = viewModel
    }
    
    func start() {
        let view = WorkoutEditView(viewModel: self.viewModel).environmentObject(self)
        rootViewController = UIHostingController(rootView: view)
        rootViewController.view.backgroundColor = .clear
    }
    
    func goToAddExercise() {
        let temporaryExerciseAddViewModel = ExerciseEditViewModel(parentViewModel: viewModel, editingExercise: nil)
        let exerciseAddCoordinator = ExerciseEditCoordinator(viewModel: temporaryExerciseAddViewModel)
        
        exerciseAddCoordinator.start()
        childCoordinators.append(exerciseAddCoordinator)
        
        let addExerciseViewController = exerciseAddCoordinator.rootViewController
        addExerciseViewController.modalPresentationStyle = .formSheet
        rootViewController.present(addExerciseViewController, animated: true)
    }
    
    func goToAdvancedEditRestPeriod() {
        let temporaryRestTimeViewModel = RestTimeEditViewModel(parentViewModel: viewModel)
        let restTimeCoordinator = RestTimeEditCoordinator(viewModel: temporaryRestTimeViewModel)
        
        restTimeCoordinator.start()
        childCoordinators.append(restTimeCoordinator)
        
        let restTimeViewController = restTimeCoordinator.rootViewController
        restTimeViewController.modalPresentationStyle = .formSheet
        rootViewController.present(restTimeViewController, animated: true)
    }
    
    func goToEditWorkout(exerciseToEdit: ExerciseEntity) {
        let temporaryExerciseEditViewModel = ExerciseEditViewModel(parentViewModel: viewModel, editingExercise: exerciseToEdit)
        let exerciseEditCoordinator = ExerciseEditCoordinator(viewModel: temporaryExerciseEditViewModel)
        
        exerciseEditCoordinator.start()
        childCoordinators.append(exerciseEditCoordinator)
        
        let editExerciseViewController = exerciseEditCoordinator.rootViewController
        editExerciseViewController.modalPresentationStyle = .formSheet
        rootViewController.present(editExerciseViewController, animated: true)
    }
    
    func saveWorkoutEdit(){
        if #available(iOS 15, *) {
            print("Workout Coordinator: Save \(Date.now)")
        } else {
            print("Workout Coordinator: Save")
        }
        viewModel.saveWorkout()
        rootViewController.navigationController?.popViewController(animated: true)
    }
    
    func discardWorkoutEdit(){
        if #available(iOS 15, *) {
            print("Workout Coordinator: Discard \(Date.now)")
        } else {
            print("Workout Coordinator: Discard")
        }
        viewModel.discardWorkout()
        rootViewController.navigationController?.popViewController(animated: true)
    }
}

