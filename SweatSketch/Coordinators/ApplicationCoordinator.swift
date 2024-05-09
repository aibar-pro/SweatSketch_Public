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
    
    let applicationEvent = PassthroughSubject<ApplicationEventType, Never>()
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
        applicationEvent
            .print("App Coordinator: Workout Event")
            .sink { [weak self] event in
                guard let self = self else { return }
                
                switch event {
                case .workoutStarted(let workoutUUID):
                    showActiveWorkout(with: workoutUUID)
                case .catalogRequested:
                    showWorkoutCollection()
                case .collectionRequested(let collectionUUID):
                    showWorkoutCollection(with: collectionUUID)
                case .profileRequested:
                    showProfile()
                }
            }
            .store(in: &cancellables)
    }
    
    private func showActiveWorkout(with workoutUUID: UUID) {
        UserDefaults.standard.set(workoutUUID.uuidString, forKey: UserDefaultsKeys.activeWorkoutUUID)
        
        do {
            let activeWorkoutCoordinator = try ActiveWorkoutCoordinator(dataContext: dataContext, activeWorkoutUUID: workoutUUID, applicationEvent: self.applicationEvent)
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
    
    private func showWorkoutCollection(with collectionUUID: UUID?) {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.activeWorkoutUUID)
        
        let workoutCollectionCoordinator = WorkoutCollectionCoordinator(dataContext: dataContext, applicationEvent: self.applicationEvent, collectionUUID: collectionUUID)
        workoutCollectionCoordinator.start()
        
        if let openedCollectionUUID = workoutCollectionCoordinator.viewModel.workoutCollection.uuid {
            UserDefaults.standard.set(openedCollectionUUID.uuidString, forKey: UserDefaultsKeys.lastOpenedCollectionUUID)
        }
        
        self.childCoordinators.append(workoutCollectionCoordinator)
        self.rootViewController.popToRootViewController(animated: true)
        self.rootViewController.viewControllers = [workoutCollectionCoordinator.rootViewController]
    }
    
    private func showWorkoutCollection() {
        let workoutCollectionCoordinator = WorkoutCatalogCoordinator(dataContext: dataContext, applicationEvent: self.applicationEvent)
        workoutCollectionCoordinator.start()
            
        self.childCoordinators.append(workoutCollectionCoordinator)
        self.rootViewController.popToRootViewController(animated: true)
        self.rootViewController.viewControllers = [workoutCollectionCoordinator.rootViewController]
    }
    
    private func showProfile() {
        let loginCoordinator = UserProfileCoordinator(applicationEvent: self.applicationEvent)
        loginCoordinator.start()
        
        let loginViewController = loginCoordinator.rootViewController
        loginViewController.modalPresentationStyle = .formSheet
        rootViewController.present(loginViewController, animated: true)
        
//        self.childCoordinators.append(loginCoordinator)
//        self.rootViewController.popToRootViewController(animated: true)
//        self.rootViewController.viewControllers = [loginCoordinator.rootViewController]
    }
    
    func checkActiveWorkoutValue() {
        if let activeWorkoutUUIDString = UserDefaults.standard.string(forKey: UserDefaultsKeys.activeWorkoutUUID),
           let workoutUUID = UUID(uuidString: activeWorkoutUUIDString) {
            applicationEvent.send(.workoutStarted(workoutUUID))
        } else if let lastOpenedCollectionUUID = UserDefaults.standard.string(forKey: UserDefaultsKeys.lastOpenedCollectionUUID),
        let collectionUUID = UUID(uuidString: lastOpenedCollectionUUID) {
            applicationEvent.send(.collectionRequested(collectionUUID))
            print("No active workout in UserDefaults. Opening last collection")
        } else {
            applicationEvent.send(.collectionRequested(nil))
            print("Opening default collection")
        }
    }
    
}
