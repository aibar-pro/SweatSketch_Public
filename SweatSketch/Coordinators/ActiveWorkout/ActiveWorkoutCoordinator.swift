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
    var activeWorkoutService: ActiveWorkoutService
    
    var rootViewController = UIViewController()
    var childCoordinators = [Coordinator]()
    
    let applicationEvent: PassthroughSubject<ApplicationEventType, Never>
    
    init(dataContext: NSManagedObjectContext, activeWorkoutUUID: UUID, applicationEvent: PassthroughSubject<ApplicationEventType, Never>) throws {
        rootViewController = UIViewController()
        
        self.activeWorkoutService = ActiveWorkoutService.shared
        self.viewModel = try ActiveWorkoutViewModel(activeWorkoutUUID: activeWorkoutUUID, in: dataContext)
        self.activeWorkoutService.workoutManager = self.viewModel
        
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
        let workoutDuration = viewModel.totalWorkoutDuration
        
        let view = ActiveWorkoutSummaryView(
            workoutDuration: workoutDuration,
            onProceed: {
                Task {
                    await self.viewModel.endActivity()
                }
                self.goToCollection()
            },
            onDismiss: viewModel.startTimer)
            .environmentObject(self)
        
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
