//
//  UserProfileCoordinator.swift
//  SweatSketch
//
//  Created by aibaranchikov on 09.05.2024.
//

import SwiftUI
import Combine

class UserProfileCoordinator: BaseCoordinator, Coordinator {
    let applicationEvent: PassthroughSubject<ApplicationEventType, Never>
    
    var cancellables = Set<AnyCancellable>()
    
    init(applicationEvent: PassthroughSubject<ApplicationEventType, Never>) {
        self.applicationEvent = applicationEvent
    }
    
    func start() {
        if UserSession.shared.isLoggedIn {
            presentUserProfileScreen()
        } else {
            showLogin()
        }
    }
    
    private func presentUserProfileScreen() {
        let coordinator = UserProfileViewCoordinator()
        
        coordinator.delegate = self
        coordinator.start()
        childCoordinators.append(coordinator)
        rootViewController = coordinator.rootViewController
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
                ErrorManager.shared.displayError(message: "Logout failed: \(error.localizedDescription)")
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
        // Task { @MainActor in -- is also a viable option 
        Just(())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.applicationEvent.send(.profileRequested)
            }
            .store(in: &cancellables)
    }
    
    func didRequestProfileUpdate(userProfile: UserProfileModel) {
        Task {
            do {
                let result = try await NetworkService.shared.updateUser(userProfile: userProfile)
                if result {
                    print("COORDINATOR: Profile update successful")
                    didRequestProfile()
                }
            } catch {
                ErrorManager.shared.displayError(message: "Profile update failed: \(error.localizedDescription)")
                print("COORDINATOR: Profile update error. \(error)")
            }
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
