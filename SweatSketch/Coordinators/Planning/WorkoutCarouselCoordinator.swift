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
    
    var childCoordinators = [Coordinator]()
    var rootViewController = UIViewController()
    
    let workoutEvent: PassthroughSubject<WorkoutEventType, Never>
    
    init(dataContext: NSManagedObjectContext, workoutEvent: PassthroughSubject<WorkoutEventType, Never>, collectionUUID: UUID?) {
        rootViewController = UIViewController()
        viewModel = WorkoutCarouselViewModel(context: dataContext, collectionUUID: collectionUUID)
        self.workoutEvent = workoutEvent
    }
    
    func startWorkout(workoutIndex: Int) {
        let launchedWorkoutUUID = viewModel.workouts[workoutIndex].id
        workoutEvent.send(.started(launchedWorkoutUUID))
    }
    
    func enterCollections() {
        workoutEvent.send(.enterCollections)
    }
    
    func goToAddWorkout() {
        let temporaryWorkoutAddViewModel = WorkoutEditViewModel(parentViewModel: viewModel, editingWorkoutUUID: nil)
        let workoutAddCoordinator = WorkoutEditCoordinator(viewModel: temporaryWorkoutAddViewModel)
        
        workoutAddCoordinator.start()
        childCoordinators.append(workoutAddCoordinator)
        
        let addWorkoutViewController = workoutAddCoordinator.rootViewController
        rootViewController.navigationController?.pushViewController(addWorkoutViewController, animated: true)
        
        viewModel.objectWillChange.send()
    }
    
    func goToEditWorkout(workoutIndex: Int) {
        let editingWorkoutUUID = viewModel.workouts[workoutIndex].id
        let temporaryWorkoutEditViewModel = WorkoutEditViewModel(parentViewModel: viewModel, editingWorkoutUUID: editingWorkoutUUID)
        let workoutEditCoordinator = WorkoutEditCoordinator(viewModel: temporaryWorkoutEditViewModel)
        
        workoutEditCoordinator.start()
        childCoordinators.append(workoutEditCoordinator)
        
        let editWorkoutViewController = workoutEditCoordinator.rootViewController
        rootViewController.navigationController?.pushViewController(editWorkoutViewController, animated: true)
    }
    
    func goToWorkoutLst() {
        let temporaryWorkoutListViewModel = WorkoutListViewModel(parentViewModel: viewModel, workoutCollection: viewModel.workoutCollection)
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
