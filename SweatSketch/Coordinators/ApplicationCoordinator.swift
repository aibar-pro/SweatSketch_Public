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
                    showWorkoutCarousel(with: nil)
                case .enterCollections:
                    showWorkoutCollection()
                case .openCollection(let collectionUUID):
                    showWorkoutCarousel(with: collectionUUID)
                }
            }
            .store(in: &cancellables)
    }
    
    private func showActiveWorkout(with workoutUUID: UUID) {
        UserDefaults.standard.set(workoutUUID.uuidString, forKey: UserDefaultsKeys.activeWorkoutUUID)
        
        do {
            let activeWorkoutCoordinator = try ActiveWorkoutCoordinator(dataContext: dataContext, activeWorkoutUUID: workoutUUID, workoutEvent: self.workoutEvent)
            activeWorkoutCoordinator.start()
            
            self.childCoordinators.append(activeWorkoutCoordinator)
            self.rootViewController.popToRootViewController(animated: true)
            self.rootViewController.viewControllers = [activeWorkoutCoordinator.rootViewController]
        } catch ActiveWorkoutError.invalidWorkoutUUID {
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.activeWorkoutUUID)
            checkActiveWorkoutValue()
            print("Error launching workout with UUID: \(workoutUUID.uuidString). Returning to collection")
        } catch {
            print("Error launching workout with UUID: \(workoutUUID.uuidString)")
        }
    }
    
    private func showWorkoutCarousel(with collectionUUID: UUID?) {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.activeWorkoutUUID)
        
        let workoutPlanningCoordinator = WorkoutCarouselCoordinator(dataContext: dataContext, workoutEvent: self.workoutEvent, collectionUUID: collectionUUID)
        workoutPlanningCoordinator.start()
        
        if let openedCollectionUUID = workoutPlanningCoordinator.viewModel.workoutCollection.uuid {
            UserDefaults.standard.set(openedCollectionUUID.uuidString, forKey: UserDefaultsKeys.lastOpenedCollectionUUID)
        }
        
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
        } else if let lastOpenedCollectionUUID = UserDefaults.standard.string(forKey: UserDefaultsKeys.lastOpenedCollectionUUID),
        let collectionUUID = UUID(uuidString: lastOpenedCollectionUUID) {
            workoutEvent.send(.openCollection(collectionUUID))
            print("No active workout in UserDefaults. Opening last collection")
        } else {
            workoutEvent.send(.finished)
            print("Open default collection")
        }
    }
    
}
