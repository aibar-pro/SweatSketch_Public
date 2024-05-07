//
//  ActiveWorkoutCoordinator.swift
//  SweatSketch
//
//  Created by aibaranchikov on 02.04.2024.
//

import SwiftUI
import CoreData
import Combine

class ActiveWorkoutCoordinator: ObservableObject, Coordinator {
    
    var viewModel: ActiveWorkoutViewModel
    
    var rootViewController = UIViewController()
    var childCoordinators = [Coordinator]()
    
    let applicationEvent: PassthroughSubject<ApplicationEventType, Never>
    
    init(dataContext: NSManagedObjectContext, activeWorkoutUUID: UUID, applicationEvent: PassthroughSubject<ApplicationEventType, Never>) throws {
        rootViewController = UIViewController()
        viewModel = try ActiveWorkoutViewModel(activeWorkoutUUID: activeWorkoutUUID, in: dataContext)
        self.applicationEvent = applicationEvent
    }
    
    func start() {
        let view = ActiveWorkoutView(viewModel: self.viewModel).environmentObject(self)
        rootViewController = UIHostingController(rootView: view)
        rootViewController.view.backgroundColor = .clear
        
        print("Active Workout Coordinator: Start")
        viewModel.startTimer()
        viewModel.startActivity()
    }
    
    func goToWorkoutSummary() {
        viewModel.stopTimer()
        Task {
            await viewModel.endActivity()
        }
        
        let workoutDuration = viewModel.totalWorkoutDuration
        
        let view = ActiveWorkoutSummaryView(workoutDuration: workoutDuration, onDismiss: {
            self.viewModel.startTimer()
            self.viewModel.startActivity()
        }).environmentObject(self)
        
        let workoutCompletedController = UIHostingController(rootView: view)
        workoutCompletedController.modalPresentationStyle = .formSheet
        rootViewController.present(workoutCompletedController, animated: true)
    }
    
    func goToCollection(){
        if let lastOpenedCollectionUUID = UserDefaults.standard.string(forKey: UserDefaultsKeys.lastOpenedCollectionUUID),
           let collectionUUID = UUID(uuidString: lastOpenedCollectionUUID) {
            rootViewController.dismiss(animated: true)
            applicationEvent.send(.collectionRequested(collectionUUID))
        } else {
            rootViewController.dismiss(animated: true)
            applicationEvent.send(.collectionRequested(nil))
        }
        print("Active Workout Coordinator: Finish")
    }
}
