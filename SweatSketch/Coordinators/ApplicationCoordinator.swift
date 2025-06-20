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

    var rootViewController = UINavigationController()
    var childCoordinators = [Coordinator]()
    
    let dataContext: NSManagedObjectContext
    
    let applicationEvent = PassthroughSubject<ApplicationEventType, Never>()
    var cancellables = Set<AnyCancellable>()
    
    init(dataContext: NSManagedObjectContext) {
        self.rootViewController.isNavigationBarHidden = true
        self.dataContext = dataContext
    }
    
    func start() {
        setupEventSubscription()
        checkActiveWorkoutState()
    }
    
    private func setupEventSubscription() {
        applicationEvent
            .print("\(type(of: self)): Workout Event Received")
            .sink { [weak self] event in
                guard let self else { return }
                
                switch event {
                case .workoutStarted(let workoutUUID):
                    showActiveWorkout(with: workoutUUID)
                case .workoutFinished:
                    finishActiveWorkout()
                case .catalogRequested:
                    showWorkoutCatalog()
                case .collectionRequested(let collectionUUID):
                    showWorkoutCollection(with: collectionUUID, shouldFadeIn: false)
                case .profileRequested:
                    showProfile()
                }
            }
            .store(in: &cancellables)
    }
    
    private func showActiveWorkout(with workoutUUID: UUID) {
        do {
            let activeWorkoutCoordinator = try ActiveWorkoutCoordinator(dataContext: dataContext, activeWorkoutUUID: workoutUUID, applicationEvent: self.applicationEvent)
            activeWorkoutCoordinator.start()
            
            setActiveWorkoutUUID(workoutUUID)
            
            childCoordinators.append(activeWorkoutCoordinator)
            addViewPushTransition(pushDirection: .fromTop)
            rootViewController.viewControllers = [activeWorkoutCoordinator.rootViewController]
        } catch ActiveWorkoutError.invalidWorkoutUUID {
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.activeWorkoutUUID)
            checkActiveWorkoutState()
            print("\(type(of: self)): Error launching workout with UUID: \(workoutUUID.uuidString). Returning to collection")
        } catch {
            print("\(type(of: self)): Error launching workout with UUID: \(workoutUUID.uuidString)")
        }
    }
    
    private func setActiveWorkoutUUID(_ workoutUUID: UUID) {
        UserDefaults.standard.set(workoutUUID.uuidString, forKey: UserDefaultsKeys.activeWorkoutUUID)
    }
    
    private func finishActiveWorkout() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.activeWorkoutUUID)
        showLastOpenedCollection()
    }
    
    private func showLastOpenedCollection() {
        if let lastOpenedCollectionUUID = UserDefaults.standard.string(forKey: UserDefaultsKeys.lastOpenedCollectionUUID),
           let collectionUUID = UUID(uuidString: lastOpenedCollectionUUID) {
            showWorkoutCollection(with: collectionUUID)
        } else {
            showWorkoutCollection()
        }
    }

    private func showWorkoutCollection(with collectionUUID: UUID? = nil, shouldFadeIn: Bool = true) {
        let workoutCollectionCoordinator = WorkoutCollectionCoordinator(
            dataContext: dataContext,
            applicationEvent: self.applicationEvent,
            collectionUUID: collectionUUID
        )
        workoutCollectionCoordinator.start()
        
        self.childCoordinators.append(workoutCollectionCoordinator)
        if shouldFadeIn {
            addViewRevealTransition()
        } else {
            addViewPushTransition(pushDirection: .fromRight)
        }
        self.rootViewController.viewControllers = [workoutCollectionCoordinator.rootViewController]
        
        if let collectionUUID {
            self.setLastOpenedCollectionUUID(collectionUUID)
        }
    }
    
    private func setLastOpenedCollectionUUID(_ collectionUUID: UUID) {
        UserDefaults.standard.set(collectionUUID.uuidString, forKey: UserDefaultsKeys.lastOpenedCollectionUUID)
    }
    
    private func showWorkoutCatalog() {
        let workoutCatalogCoordinator = WorkoutCatalogCoordinator(dataContext: dataContext, applicationEvent: self.applicationEvent)
        workoutCatalogCoordinator.start()
        
        self.childCoordinators.append(workoutCatalogCoordinator)
        addViewPushTransition(pushDirection: .fromLeft)
        self.rootViewController.viewControllers = [workoutCatalogCoordinator.rootViewController]
    }
    
    private func showProfile() {
        let profileCoordinator = UserProfileCoordinator(applicationEvent: self.applicationEvent)
        profileCoordinator.start()
        
        self.childCoordinators.append(profileCoordinator)
        addViewPushTransition(pushDirection: .fromTop)
        self.rootViewController.viewControllers = [profileCoordinator.rootViewController]
    }
    
    func checkActiveWorkoutState() {
        if let activeWorkoutUUIDString = UserDefaults.standard.string(forKey: UserDefaultsKeys.activeWorkoutUUID),
           let workoutUUID = UUID(uuidString: activeWorkoutUUIDString) {
            showActiveWorkout(with: workoutUUID)
        } else {
            showLastOpenedCollection()
        }
    }
    
    private func addViewPushTransition(pushDirection: CATransitionSubtype) {
        rootViewController.view.layer.add(CATransition.push(pushDirection), forKey: kCATransition)
    }
    
    private func addViewRevealTransition() {
        rootViewController.view.layer.add(CATransition.reveal(), forKey: kCATransition)
    }
}
