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
    
    let workoutEvent: PassthroughSubject<WorkoutEventType, Never>
    
    init(dataContext: NSManagedObjectContext, activeWorkoutUUID: UUID, workoutEvent: PassthroughSubject<WorkoutEventType, Never>) throws {
        rootViewController = UIViewController()
        viewModel = try ActiveWorkoutViewModel(activeWorkoutUUID: activeWorkoutUUID, in: dataContext)
        self.workoutEvent = workoutEvent
    }
    
    func start() {
        let view = ActiveWorkoutView(viewModel: self.viewModel).environmentObject(self)
        rootViewController = UIHostingController(rootView: view)
        rootViewController.view.backgroundColor = .clear
        
        print("Active Workout Coordinator: Start")
    }
    
    func finishWorkout(){
        if let lastOpenedCollectionUUID = UserDefaults.standard.string(forKey: UserDefaultsKeys.lastOpenedCollectionUUID),
           let collectionUUID = UUID(uuidString: lastOpenedCollectionUUID) {
            workoutEvent.send(.openCollection(collectionUUID))
        } else {
            workoutEvent.send(.finished)
        }
        print("Active Workout Coordinator: Finish")
    }
}
