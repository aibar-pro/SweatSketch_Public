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
    
    let workoutEvent: PassthroughSubject<WorkoutEvent, Never>
    
    init(dataContext: NSManagedObjectContext, activeWorkoutUUID: UUID, workoutEvent: PassthroughSubject<WorkoutEvent, Never>) {
        rootViewController = UIViewController()
        viewModel = ActiveWorkoutViewModel(context: dataContext, activeWorkoutUUID: activeWorkoutUUID)
        self.workoutEvent = workoutEvent
    }
    
    func start() {
        let view = ActiveWorkoutView(viewModel: self.viewModel).environmentObject(self)
        rootViewController = UIHostingController(rootView: view)
        rootViewController.view.backgroundColor = .clear
        
        print("Active Workout Coordinator: Start")
    }
    
    func finishWorkout(){
        workoutEvent.send(.finished)
        print("Active Workout Coordinator: Finish")
    }
}
