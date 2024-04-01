//
//  WorkoutPlanningCoordinator.swift
//  SweatSketch
//
//  Created by aibaranchikov on 14.03.2024.
//

import Foundation
import UIKit
import SwiftUI
import CoreData

class WorkoutCarouselCoordinator: ObservableObject, Coordinator {
    
    var viewModel: WorkoutCarouselViewModel
    @Published var presentedWorkoutIndex: Int = 0
    
    var childCoordinators = [Coordinator]()
    var rootViewController = UIViewController()
    
    init(dataContext: NSManagedObjectContext) {
        rootViewController = UIViewController()
        viewModel = WorkoutCarouselViewModel(context: dataContext)
    }
    
    func getViewTitle() -> String {
        if let workoutName = viewModel.workouts[presentedWorkoutIndex].name {
            return workoutName
        } else {
            return "Workouts"
        }
    }
    
    func goToAddWorkout() {
        let temporaryWorkoutAddViewModel = WorkoutEditTemporaryViewModel(parentViewModel: viewModel, editingWorkout: nil)
        let workoutAddCoordinator = WorkoutEditCoordinator(viewModel: temporaryWorkoutAddViewModel)
        
        workoutAddCoordinator.start()
        childCoordinators.append(workoutAddCoordinator)
        
        let addWorkoutViewController = workoutAddCoordinator.rootViewController
        rootViewController.navigationController?.pushViewController(addWorkoutViewController, animated: true)
        
        viewModel.objectWillChange.send()
    }
    
    func goToEditWorkout() {
        let editingWorkout = viewModel.workouts[presentedWorkoutIndex]
        let temporaryWorkoutEditViewModel = WorkoutEditTemporaryViewModel(parentViewModel: viewModel, editingWorkout: editingWorkout)
        let workoutEditCoordinator = WorkoutEditCoordinator(viewModel: temporaryWorkoutEditViewModel)
        
        workoutEditCoordinator.start()
        childCoordinators.append(workoutEditCoordinator)
        
        let editWorkoutViewController = workoutEditCoordinator.rootViewController
        rootViewController.navigationController?.pushViewController(editWorkoutViewController, animated: true)
    }
    
    func goToWorkoutLst() {
        let temporaryWorkoutListViewModel = WorkoutListTemporaryViewModel(parentViewModel: viewModel)
        let workoutListCoordinator = WorkoutListCoordinator(viewModel: temporaryWorkoutListViewModel)
        
        workoutListCoordinator.start()
        childCoordinators.append(workoutListCoordinator)
        
        let workoutListViewController = workoutListCoordinator.rootViewController
        workoutListViewController.modalPresentationStyle = .formSheet
//        workoutListViewController.view.window?.backgroundColor = UIColor(Constants.Design.Colors.backgroundStartColor)
        rootViewController.present(workoutListViewController, animated: true)
        
//        if let window = UIApplication.shared.windows.first {
//            window.backgroundColor = UIColor(resource: .backgroundGradientEnd)
//        }
    }
    
    func start() {
        let view = WorkoutCarouselMainView(viewModel: self.viewModel).environmentObject(self)
        rootViewController = UIHostingController(rootView: view)
        rootViewController.view.backgroundColor = .clear
    }
}
