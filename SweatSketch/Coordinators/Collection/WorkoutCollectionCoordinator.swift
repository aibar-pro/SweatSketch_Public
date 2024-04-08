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
    
    func goToWorkoutCollection() {
        workoutEvent.send(.finished)
    }
}
