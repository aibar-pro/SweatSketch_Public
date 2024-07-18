//
//  UserProfileCoordinator.swift
//  SweatSketch
//
//  Created by aibaranchikov on 09.05.2024.
//

import SwiftUI
import Combine

class UserProfileCoordinator: ObservableObject, Coordinator {
    var rootViewController = UIViewController()
    var childCoordinators = [Coordinator]()
    
    let applicationEvent: PassthroughSubject<ApplicationEventType, Never>
    
    init (applicationEvent: PassthroughSubject<ApplicationEventType, Never>) {
        self.applicationEvent = applicationEvent
    }
    
    func start() {
        if UserSession.shared.isLoggedIn {
            showUserProfile()
        } else {
            showLogin()
        }
    }
    
    private func showUserProfile() {
        let userProfileViewCoordinator = UserProfileViewCoordinator()
        userProfileViewCoordinator.delegate = self
        userProfileViewCoordinator.start()
        childCoordinators.append(userProfileViewCoordinator)
        
        rootViewController = userProfileViewCoordinator.rootViewController
     }

     private func showLogin() {
         let loginCoordinator = UserProfileLoginCoordinator()
         loginCoordinator.delegate = self
         loginCoordinator.start()
         childCoordinators.append(loginCoordinator)

         rootViewController = loginCoordinator.rootViewController
     }

     private func showSignup() {
         let signupCoordinator = UserProfileSignupCoordinator()
         signupCoordinator.delegate = self
         signupCoordinator.start()
         childCoordinators.append(signupCoordinator)
         
         rootViewController.present(signupCoordinator.rootViewController, animated: true)
     }
}

extension UserProfileCoordinator: UserProfileCoordinatorDelegate {
    func didRequestLogout() {
        Task {
            do {
                let result = try await NetworkService.shared.logout()
                if result {
                    print("COORDINATOR: logout successful")
                    didRequestProfile()
                }
            } catch {
                print("COORDINATOR: logout error. \(error)")
            }
        }
    }
    
    func didRequestReturn() {
        applicationEvent.send(.catalogRequested)
    }
    
    func didRequestLogin() {
        didRequestProfile()
    }

    func didRequestProfile() {
        Task { @MainActor in
            applicationEvent.send(.profileRequested)
        }
    }

    func didRequestSignup() {
        showSignup()
    }

    func didLoginSuccessfully() {
        didRequestProfile()
    }

    func didSignupSuccessfully() {
        didRequestProfile()
    }
}
