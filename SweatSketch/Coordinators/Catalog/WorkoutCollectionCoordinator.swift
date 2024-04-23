//
//  WorkoutCollectionCoordinator.swift
//  SweatSketch
//
//  Created by aibaranchikov on 05.04.2024.
//

import SwiftUI
import CoreData
import Combine

class WorkoutCollectionCoordinator: ObservableObject, Coordinator {
    var viewModel: WorkoutCollectionViewModel
    
    var childCoordinators = [Coordinator]()
    var rootViewController = UIViewController()
    
    let workoutEvent: PassthroughSubject<WorkoutEventType, Never>
    
    init(dataContext: NSManagedObjectContext, workoutEvent: PassthroughSubject<WorkoutEventType, Never>) {
        rootViewController = UIViewController()
        viewModel = WorkoutCollectionViewModel(context: dataContext)
        self.workoutEvent = workoutEvent
    }
    
    func start() {
        let view = WorkoutCollectionMainView(viewModel: self.viewModel).environmentObject(self)
        rootViewController = UIHostingController(rootView: view)
        rootViewController.view.backgroundColor = .clear
    }
    
    func goToWorkoutCollection(collectionUUID: UUID) {
        workoutEvent.send(.openCollection(collectionUUID))
    }
    
    func goToMoveWorkout(movingWorkout: WorkoutCollectionWorkoutViewRepresentation) {
        let workoutMoveViewModel = WorkoutCollectionWorkoutMoveViewModel(parentViewModel: viewModel, movingWorkout: movingWorkout)
        let workoutMoveCoordinator = WorkoutCollectionWorkoutMoveCoordinator(viewModel: workoutMoveViewModel)
        
        workoutMoveCoordinator.start()
        childCoordinators.append(workoutMoveCoordinator)
        
        let moveWorkoutViewController = workoutMoveCoordinator.rootViewController
        moveWorkoutViewController.modalPresentationStyle = .formSheet
        rootViewController.present(moveWorkoutViewController, animated: true)
        
        viewModel.objectWillChange.send()
    }
    
    func goToMoveCollection(movingCollection: WorkoutCollectionViewRepresentation) {
        let collectionMoveViewModel = WorkoutCollectionMoveViewModel(parentViewModel: viewModel, movingCollection: movingCollection)
        let collectionMoveCoordinator = WorkoutCollectionMoveCoordinator(viewModel: collectionMoveViewModel)
        
        collectionMoveCoordinator.start()
        childCoordinators.append(collectionMoveCoordinator)
        
        let moveCollectionViewController = collectionMoveCoordinator.rootViewController
        moveCollectionViewController.modalPresentationStyle = .formSheet
        rootViewController.present(moveCollectionViewController, animated: true)
        
        viewModel.objectWillChange.send()
    }
    
    func goToMergeCollection(sourceCollection: WorkoutCollectionViewRepresentation) {
        let collectionMergeViewModel = WorkoutCollectionMergeViewModel(parentViewModel: viewModel, sourceCollection: sourceCollection)
        let collectionMergeCoordinator = WorkoutCollectionMergeCoordinator(viewModel: collectionMergeViewModel)
        
        collectionMergeCoordinator.start()
        childCoordinators.append(collectionMergeCoordinator)
        
        let mergeCollectionViewController = collectionMergeCoordinator.rootViewController
        mergeCollectionViewController.modalPresentationStyle = .formSheet
        rootViewController.present(mergeCollectionViewController, animated: true)
        
        viewModel.objectWillChange.send()
    }
}
