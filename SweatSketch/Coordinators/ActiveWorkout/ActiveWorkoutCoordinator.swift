//
//  ActiveWorkoutCoordinator.swift
//  SweatSketch
//
//  Created by aibaranchikov on 02.04.2024.
//

import SwiftUI
import CoreData
import Combine

class ActiveWorkoutCoordinator: BaseCoordinator, Coordinator {
    let applicationEvent: PassthroughSubject<ApplicationEventType, Never>
    
    let viewModel: ActiveWorkoutViewModel
    
    let activeWorkoutUUID: UUID
    let activeWorkoutService: ActiveWorkoutService
    
    init(
        dataContext: NSManagedObjectContext,
        activeWorkoutUUID: UUID,
        applicationEvent: PassthroughSubject<ApplicationEventType, Never>
    ) throws {
        self.activeWorkoutUUID = activeWorkoutUUID
        self.viewModel = try ActiveWorkoutViewModel(activeWorkoutUUID: activeWorkoutUUID, in: dataContext)
        
        self.activeWorkoutService = ActiveWorkoutService.shared
        self.activeWorkoutService.workoutManager = self.viewModel
        
        self.applicationEvent = applicationEvent
        
        super.init()
    }
    
    func start() {
        let view = ActiveWorkoutView(viewModel: self.viewModel).environmentObject(self)
        rootViewController = UIHostingController(rootView: view)
        rootViewController.view.backgroundColor = .clear
        
        print("Active Workout Coordinator: Start")
        viewModel.startWorkout()
    }
    
    func goToWorkoutSummary() {
        viewModel.stopWorkoutTimer()
        let workoutDuration = viewModel.totalWorkoutDuration
        
        let view = ActiveWorkoutSummaryView(
            workoutDuration: workoutDuration,
            onProceed: {
                Task {
                    await self.viewModel.endLiveActivity()
                    await MainActor.run {
                        self.finishWorkout()
                    }
                }
            },
            onDismiss: viewModel.startWorkoutTimer)
            .environmentObject(self)
        
        let workoutCompletedController = UIHostingController(rootView: view)
        workoutCompletedController.modalPresentationStyle = .pageSheet
        rootViewController.present(workoutCompletedController, animated: true)
    }
    
    private func finishWorkout() {
        print("\(type(of: self)): Active workout UUID \(activeWorkoutUUID) finished")
        rootViewController.dismiss(animated: false)
        //TODO: Fix transition
//        addViewFadeTransition()
//        rootViewController.navigationController?.popViewController(animated: false)
        applicationEvent.send(.workoutFinished(activeWorkoutUUID))
    }
}
