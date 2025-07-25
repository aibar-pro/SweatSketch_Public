//
//  WorkoutCollectionCoordinator.swift
//  SweatSketch
//
//  Created by aibaranchikov on 14.03.2024.
//

import SwiftUI
import CoreData
import Combine

class WorkoutCollectionCoordinator: BaseCoordinator, Coordinator {
    let applicationEvent: PassthroughSubject<ApplicationEventType, Never>
    
    let viewModel: WorkoutCollectionViewModel
    
    init(
        dataContext: NSManagedObjectContext,
        applicationEvent: PassthroughSubject<ApplicationEventType, Never>,
        collectionUUID: UUID?
    ) {
        self.applicationEvent = applicationEvent
        
        self.viewModel = WorkoutCollectionViewModel(context: dataContext, collectionUUID: collectionUUID)
        super.init()
    }
    
    func startWorkout(workoutIndex: Int) {
        let launchedWorkoutUUID = viewModel.workouts[workoutIndex].id
        applicationEvent.send(.workoutStarted(launchedWorkoutUUID))
    }
    
    func goToCatalog() {
        applicationEvent.send(.catalogRequested)
    }
    
    func goToAddWorkout() {
        guard let workoutEditViewModel = WorkoutEditorModel(parent: viewModel, editingWorkoutUUID: nil)
        else {
            print("\(type(of: self)): \(#function): Failed to initialize WorkoutEditViewModel")
            return
        }
        
        presentEditWorkoutViewController(using: workoutEditViewModel)
    }
    
    func goToEditWorkout(workoutIndex: Int) {
        guard let workoutId = viewModel.workouts[safe: workoutIndex]?.id,
              let workoutEditViewModel = WorkoutEditorModel(parent: viewModel, editingWorkoutUUID: workoutId)
        else {
            print("\(type(of: self)): \(#function): Failed to initialize WorkoutEditViewModel")
            return
        }
        
        presentEditWorkoutViewController(using: workoutEditViewModel)
    }
    
    private func presentEditWorkoutViewController(using viewModel: WorkoutEditorModel) {
        let workoutEditCoordinator = WorkoutEditorCoordinator(viewModel: viewModel)
        
        workoutEditCoordinator.start()
        childCoordinators.append(workoutEditCoordinator)
        
        let workoutEditViewController = workoutEditCoordinator.rootViewController
        addViewPushTransition(pushDirection: .fromBottom)
        rootViewController.navigationController?.pushViewController(workoutEditViewController, animated: false)
    }
    
    func goToWorkoutLst() {
        let temporaryWorkoutListViewModel = CollectionEditorModel(parent: viewModel, workoutCollection: viewModel.workoutCollection)
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
