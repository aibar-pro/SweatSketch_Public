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
        UserDefaults.standard.set(collectionUUID.uuidString, forKey: UserDefaultsKeys.lastOpenedCollectionUUID)
    }
    
    func goToAddCollection() {
        let collectionAddViewModel = WorkoutCollectionEditViewModel(parentViewModel: viewModel, editingCollectionUUID: nil)
        let collectionAddCoordinator = WorkoutCollectionEditCoordinator(viewModel: collectionAddViewModel)
        
        collectionAddCoordinator.start()
        childCoordinators.append(collectionAddCoordinator)
        
        let addCollectionViewController = collectionAddCoordinator.rootViewController
        addCollectionViewController.modalPresentationStyle = .formSheet
        rootViewController.present(addCollectionViewController, animated: true)
        
        viewModel.objectWillChange.send()
    }
}
