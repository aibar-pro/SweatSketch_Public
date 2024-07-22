//
//  UserProfileLoginCoordinator.swift
//  SweatSketch
//
//  Created by aibaranchikov on 26.06.2024.
//

import Foundation
import UIKit
import SwiftUI

class UserProfileLoginCoordinator: Coordinator, ObservableObject {
    var rootViewController = UIViewController()
    weak var delegate: UserProfileCoordinatorDelegate?
    
    func start() {
        let loginView = UserProfileLoginView(
            onLogin: { [weak self] user in
                guard let self = self else { return }
                handleLogin(user: user)
            },
            onDismiss: { [weak self] in
                self?.delegate?.didRequestReturn()
            },
            onSignup: { [weak self] in
                self?.delegate?.didRequestSignup()
            }
        )
        rootViewController = UIHostingController(rootView: loginView)
        rootViewController.view.backgroundColor = .clear
    }

    private func handleLogin(user: UserCredentialModel) {
        Task {
            do {
                let success = try await NetworkService.shared.login(user: user)
                if success {
                    self.delegate?.didLoginSuccessfully()
                    print("COORDINATOR: LOGIN SUCCESSFUL")
                }
            } catch {
                print("Login failed with error: \(error.localizedDescription)")
            }
        }
    }
}
