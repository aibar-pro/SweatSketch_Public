//
//  WorkoutPlanningCoordinator.swift
//  SweatSketch
//
//  Created by aibaranchikov on 14.03.2024.
//

import SwiftUI
import CoreData
import Combine

class WorkoutCarouselCoordinator: ObservableObject, Coordinator {
    
    var viewModel: WorkoutCarouselViewModel
    @Published var presentedWorkoutIndex: Int = 0
    
    var childCoordinators = [Coordinator]()
    var rootViewController = UIViewController()
    
    let workoutEvent: PassthroughSubject<WorkoutEventType, Never>
    
    init(dataContext: NSManagedObjectContext, workoutEvent: PassthroughSubject<WorkoutEventType, Never>) {
        rootViewController = UIViewController()
        viewModel = WorkoutCarouselViewModel(context: dataContext)
        self.workoutEvent = workoutEvent
    }
    
    func startWorkout() {
        if let launchedWorkout = viewModel.workouts[presentedWorkoutIndex].uuid {
            workoutEvent.send(.started(launchedWorkout))
        }
    }
    
    func enterCollections() {
        workoutEvent.send(.enterCollections)
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
        let temporaryWorkoutListViewModel = WorkoutListTemporaryViewModel(parentViewModel: viewModel, workoutCollection: viewModel.workoutCollection)
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
