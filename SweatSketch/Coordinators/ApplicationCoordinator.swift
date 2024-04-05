//
//  ApplicationCoordinator.swift
//  SweatSketch
//
//  Created by aibaranchikov on 13.03.2024.
//

import UIKit
import Combine
import CoreData

class ApplicationCoordinator: ObservableObject, Coordinator {

    var rootViewController: UINavigationController
    var childCoordinators = [Coordinator]()
    
    let dataContext: NSManagedObjectContext
    
    let workoutEvent = PassthroughSubject<WorkoutEventType, Never>()
    var cancellables = Set<AnyCancellable>()
    
    init(dataContext: NSManagedObjectContext) {
        self.rootViewController = UINavigationController()
        self.rootViewController.isNavigationBarHidden = true
        self.dataContext = dataContext
    }
    
    func start() {
        setupEventSubscription()
        checkActiveWorkoutValue()
    }
    
    private func setupEventSubscription() {
        workoutEvent
            .print("App Coordinator: Workout Event")
            .sink { [weak self] event in
                guard let self = self else { return }
                
                switch event {
                case .started(let workoutUUID):
                    showActiveWorkout(with: workoutUUID)
                case .finished:
                    showWorkoutCarousel()
                case .enterCollections:
                    showWorkoutCollection()
                }
            }
            .store(in: &cancellables)
    }
    
    private func showActiveWorkout(with workoutUUID: UUID) {
        UserDefaults.standard.set(workoutUUID.uuidString, forKey: UserDefaultsKeys.activeWorkoutUUID)
        
        let activeWorkoutCoordinator = ActiveWorkoutCoordinator(dataContext: dataContext, activeWorkoutUUID: workoutUUID, workoutEvent: self.workoutEvent)
        activeWorkoutCoordinator.start()
        
        self.childCoordinators.append(activeWorkoutCoordinator)
        self.rootViewController.popToRootViewController(animated: true)
        self.rootViewController.viewControllers = [activeWorkoutCoordinator.rootViewController]
    }
    
    private func showWorkoutCarousel() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.activeWorkoutUUID)
            
        let workoutPlanningCoordinator = WorkoutCarouselCoordinator(dataContext: dataContext, workoutEvent: self.workoutEvent)
        workoutPlanningCoordinator.start()
            
        self.childCoordinators.append(workoutPlanningCoordinator)
        self.rootViewController.popToRootViewController(animated: true)
        self.rootViewController.viewControllers = [workoutPlanningCoordinator.rootViewController]
    }
    
    private func showWorkoutCollection() {
        let workoutCollectionCoordinator = WorkoutCollectionCoordinator(dataContext: dataContext, workoutEvent: self.workoutEvent)
        workoutCollectionCoordinator.start()
            
        self.childCoordinators.append(workoutCollectionCoordinator)
        self.rootViewController.popToRootViewController(animated: true)
        self.rootViewController.viewControllers = [workoutCollectionCoordinator.rootViewController]
    }
    
    func checkActiveWorkoutValue() {
        if let activeWorkoutUUIDString = UserDefaults.standard.string(forKey: UserDefaultsKeys.activeWorkoutUUID),
           let workoutUUID = UUID(uuidString: activeWorkoutUUIDString) {
            workoutEvent.send(.started(workoutUUID))
        } else {
            workoutEvent.send(.finished)
            print("Nothing in UserDefaults")
        }
    }
    
}
