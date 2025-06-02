//
//  WorkoutCollectionCoordinator.swift
//  SweatSketch
//
//  Created by aibaranchikov on 14.03.2024.
//

import SwiftUI
import CoreData
import Combine

class WorkoutCollectionCoordinator: BaseCoordinator<WorkoutCollectionViewModel>, Coordinator {
    let applicationEvent: PassthroughSubject<ApplicationEventType, Never>
    
    init(dataContext: NSManagedObjectContext,
         applicationEvent: PassthroughSubject<ApplicationEventType, Never>,
         collectionUUID: UUID?) {
        self.applicationEvent = applicationEvent
        
        let viewModel = WorkoutCollectionViewModel(context: dataContext, collectionUUID: collectionUUID)
        super.init(viewModel: viewModel)
    }
    
    func startWorkout(workoutIndex: Int) {
        let launchedWorkoutUUID = viewModel.workouts[workoutIndex].id
        applicationEvent.send(.workoutStarted(launchedWorkoutUUID))
    }
    
    func goToCatalog() {
        applicationEvent.send(.catalogRequested)
    }
    
    func goToAddWorkout() {
        let temporaryWorkoutAddViewModel = WorkoutEditViewModel(parentViewModel: viewModel, editingWorkoutUUID: nil)
        let workoutAddCoordinator = WorkoutEditCoordinator(viewModel: temporaryWorkoutAddViewModel)
        
        workoutAddCoordinator.start()
        childCoordinators.append(workoutAddCoordinator)
        
        let addWorkoutViewController = workoutAddCoordinator.rootViewController
        addViewPushTransition(pushDirection: .fromBottom)
        rootViewController.navigationController?.pushViewController(addWorkoutViewController, animated: false)
    }
    
    func goToEditWorkout(workoutIndex: Int) {
        let editingWorkoutUUID = viewModel.workouts[workoutIndex].id
        let temporaryWorkoutEditViewModel = WorkoutEditViewModel(parentViewModel: viewModel, editingWorkoutUUID: editingWorkoutUUID)
        let workoutEditCoordinator = WorkoutEditCoordinator(viewModel: temporaryWorkoutEditViewModel)
        
        workoutEditCoordinator.start()
        childCoordinators.append(workoutEditCoordinator)
        
        let editWorkoutViewController = workoutEditCoordinator.rootViewController
        addViewPushTransition(pushDirection: .fromBottom)
        rootViewController.navigationController?.pushViewController(editWorkoutViewController, animated: false)
    }
    
    func goToWorkoutLst() {
        let temporaryWorkoutListViewModel = WorkoutCollectionListViewModel(parentViewModel: viewModel, workoutCollection: viewModel.workoutCollection)
        let workoutListCoordinator = WorkoutCollectionListCoordinator(viewModel: temporaryWorkoutListViewModel)
        
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
        let view = WorkoutCollectionView(viewModel: self.viewModel).environmentObject(self)
        rootViewController = UIHostingController(rootView: view)
        rootViewController.view.backgroundColor = .clear
    }
}
