//
//  ActiveWorkoutCoordinator.swift
//  SweatSketch
//
//  Created by aibaranchikov on 02.04.2024.
//

import SwiftUI
import CoreData
import Combine

class ActiveWorkoutCoordinator: BaseCoordinator<ActiveWorkoutViewModel>, Coordinator {
    var activeWorkoutService: ActiveWorkoutService
    
    let applicationEvent: PassthroughSubject<ApplicationEventType, Never>
    
    let activeWorkoutUUID: UUID
    
    init(dataContext: NSManagedObjectContext, activeWorkoutUUID: UUID, applicationEvent: PassthroughSubject<ApplicationEventType, Never>) throws {
        self.activeWorkoutService = ActiveWorkoutService.shared
        self.activeWorkoutUUID = activeWorkoutUUID
        self.applicationEvent = applicationEvent
        
        let viewModel = try ActiveWorkoutViewModel(activeWorkoutUUID: activeWorkoutUUID, in: dataContext)
        super.init(viewModel: viewModel)
        
        self.activeWorkoutService.workoutManager = self.viewModel
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
                    await MainActor.run {
                        self.finishWorkout()
                    }
                }
            },
            onDismiss: viewModel.startTimer)
            .environmentObject(self)
        
        let workoutCompletedController = UIHostingController(rootView: view)
        workoutCompletedController.modalPresentationStyle = .formSheet
        rootViewController.present(workoutCompletedController, animated: true)
    }
    
    private func finishWorkout(){
        print("\(type(of: self)): Active workout UUID \(activeWorkoutUUID) finished")
        rootViewController.dismiss(animated: false)
        //TODO: Fix transition
//        addViewFadeTransition()
//        rootViewController.navigationController?.popViewController(animated: false)
        applicationEvent.send(.workoutFinished(activeWorkoutUUID))
    }
}
