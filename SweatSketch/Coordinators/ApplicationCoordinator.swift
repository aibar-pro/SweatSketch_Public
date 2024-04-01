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
    
//    let workoutStarted = PassthroughSubject<UUID, Never>()
//    let workoutFinished = PassthroughSubject<Void, Never>()
    let workoutEvent = PassthroughSubject<WorkoutEvent, Never>()
    var cancellables = Set<AnyCancellable>()
    
    init(dataContext: NSManagedObjectContext) {
        self.rootViewController = UINavigationController()
        self.rootViewController.isNavigationBarHidden = true
        self.dataContext = dataContext
    }
    
    func start() {
        
        
        workoutEvent
            .print("App Coordinator: Workout Event")
            .sink { [weak self] event in
                guard let self = self else { return }
                
                switch event {
                case .started(let workoutUUID):
                    UserDefaults.standard.set(workoutUUID.uuidString, forKey: UserDefaultsKeys.activeWorkoutUUID)
                    
                    let activeWorkoutCoordinator = ActiveWorkoutCoordinator(dataContext: dataContext, activeWorkoutUUID: workoutUUID, workoutEvent: self.workoutEvent)
                    activeWorkoutCoordinator.start()
                    
                    self.childCoordinators.append(activeWorkoutCoordinator)
                    self.rootViewController.popToRootViewController(animated: true)
                    self.rootViewController.viewControllers = [activeWorkoutCoordinator.rootViewController]
                case .finished:
                    UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.activeWorkoutUUID)
                        
                    let workoutPlanningCoordinator = WorkoutCarouselCoordinator(dataContext: dataContext, workoutEvent: self.workoutEvent)
                    workoutPlanningCoordinator.start()
                        
                    self.childCoordinators.append(workoutPlanningCoordinator)
                    self.rootViewController.popToRootViewController(animated: true)
                    self.rootViewController.viewControllers = [workoutPlanningCoordinator.rootViewController]
                }
                
            }
            .store(in: &cancellables)
        
        checkActiveWorkoutValue()
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
