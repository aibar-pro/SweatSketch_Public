//
//  WorkoutEditCoordinators.swift
//  SweatSketch
//
//  Created by aibaranchikov on 15.03.2024.
//

import Foundation
import SwiftUI

class WorkoutEditCoordinator: ObservableObject, Coordinator {
    
    var viewModel: WorkoutEditTemporaryViewModel
    
    var rootViewController = UIViewController()
    var childCoordinators = [Coordinator]()
    
    init(viewModel: WorkoutEditTemporaryViewModel) {
        rootViewController = UIViewController()
        self.viewModel = viewModel
    }
    
    func start() {
        let view = WorkoutEditView(viewModel: self.viewModel).environmentObject(self)
        rootViewController = UIHostingController(rootView: view)
    }
    
    func goToAddExercise() {
        let temporaryExerciseAddViewModel = ExerciseEditTemporaryViewModel(parentViewModel: viewModel, editingExercise: nil)
        let exerciseAddCoordinator = ExerciseEditCoordinator(viewModel: temporaryExerciseAddViewModel)
        
        exerciseAddCoordinator.start()
        childCoordinators.append(exerciseAddCoordinator)
        
        let addExerciseViewController = exerciseAddCoordinator.rootViewController
        addExerciseViewController.modalPresentationStyle = .formSheet
        rootViewController.present(addExerciseViewController, animated: true)
    }
    
    func goToEditWorkout(exerciseToEdit: ExerciseEntity) {
        let temporaryExerciseEditViewModel = ExerciseEditTemporaryViewModel(parentViewModel: viewModel, editingExercise: exerciseToEdit)
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
