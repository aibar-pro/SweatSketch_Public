//
//  WorkoutCatalogCoordinator.swift
//  SweatSketch
//
//  Created by aibaranchikov on 05.04.2024.
//

import SwiftUI
import CoreData
import Combine

class WorkoutCatalogCoordinator: BaseCoordinator, Coordinator {
    let applicationEvent: PassthroughSubject<ApplicationEventType, Never>
    
    let viewModel: WorkoutCatalogViewModel
    
    init(dataContext: NSManagedObjectContext, applicationEvent: PassthroughSubject<ApplicationEventType, Never>) {
        self.applicationEvent = applicationEvent
        self.viewModel = WorkoutCatalogViewModel(context: dataContext)
        
        super.init()
    }
    
    func start() {
        let view = WorkoutCatalogMainView(viewModel: self.viewModel).environmentObject(self)
        rootViewController = UIHostingController(rootView: view)
        rootViewController.view.backgroundColor = .clear
    }
    
    func goToWorkoutCollection(collectionUUID: UUID) {
        applicationEvent.send(.collectionRequested(collectionUUID))
    }
    
    func goToProfile() {
        applicationEvent.send(.profileRequested)
    }
    
    func goToShareWorkout(movingWorkout: WorkoutRepresentation) {
//        let workoutMoveViewModel = WorkoutCatalogWorkoutMoveViewModel(parentViewModel: viewModel, movingWorkout: movingWorkout)
//        let workoutMoveCoordinator = WorkoutCatalogWorkoutMoveCoordinator(viewModel: workoutMoveViewModel)
//        
//        workoutMoveCoordinator.start()
//        childCoordinators.append(workoutMoveCoordinator)
        
//        let moveWorkoutViewController = workoutMoveCoordinator.rootViewController
        let shareWorkoutViewController = UIHostingController(rootView: Text("Share Workout"))
        shareWorkoutViewController.modalPresentationStyle = .formSheet
        rootViewController.present(shareWorkoutViewController, animated: true)
    }
    
    func goToMoveWorkout(movingWorkout: WorkoutRepresentation) {
        let workoutMoveViewModel = WorkoutCatalogWorkoutMoveViewModel(parentViewModel: viewModel, movingWorkout: movingWorkout)
        let workoutMoveCoordinator = WorkoutCatalogWorkoutMoveCoordinator(viewModel: workoutMoveViewModel)
        
        workoutMoveCoordinator.start()
        childCoordinators.append(workoutMoveCoordinator)
        
        let moveWorkoutViewController = workoutMoveCoordinator.rootViewController
        moveWorkoutViewController.modalPresentationStyle = .formSheet
        rootViewController.present(moveWorkoutViewController, animated: true)
    }
    
    func goToMoveCollection(movingCollection: CollectionRepresentation) {
        let collectionMoveViewModel = WorkoutCatalogCollectionMoveViewModel(parentViewModel: viewModel, movingCollection: movingCollection)
        let collectionMoveCoordinator = WorkoutCatalogCollectionMoveCoordinator(viewModel: collectionMoveViewModel)
        
        collectionMoveCoordinator.start()
        childCoordinators.append(collectionMoveCoordinator)
        
        let moveCollectionViewController = collectionMoveCoordinator.rootViewController
        moveCollectionViewController.modalPresentationStyle = .formSheet
        rootViewController.present(moveCollectionViewController, animated: true)
    }
    
    func goToMergeCollection(sourceCollection: CollectionRepresentation) {
        let collectionMergeViewModel = WorkoutCatalogCollectionMergeViewModel(parentViewModel: viewModel, sourceCollection: sourceCollection)
        let collectionMergeCoordinator = WorkoutCatalogCollectionMergeCoordinator(viewModel: collectionMergeViewModel)
        
        collectionMergeCoordinator.start()
        childCoordinators.append(collectionMergeCoordinator)
        
        let mergeCollectionViewController = collectionMergeCoordinator.rootViewController
        mergeCollectionViewController.modalPresentationStyle = .formSheet
        rootViewController.present(mergeCollectionViewController, animated: true)
    }
}
