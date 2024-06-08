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
        rootViewController = UIViewController()
        self.applicationEvent = applicationEvent
    }
    
    func start() {
        let view = UserProfileLoginView(onLogin: { user in
                print("LOGIN COORDINATOR: LOGIN")

            NetworkService.shared.login(user: user){ [weak self] result in
                    DispatchQueue.main.async {
                        guard self != nil else { return }
                        
                        switch result {
                        case .success(let response):
                            print("LOGGED IN: \(response.accessToken)")
                            self?.rootViewController.dismiss(animated: true)
                            self?.applicationEvent.send(.catalogRequested)
                            UserDefaults.standard.set(true, forKey: UserDefaultsKeys.isUserLoggedIn)
                        case .failure(let error):
                            print("LOGIN ERROR: \(error.localizedDescription)")
                        }
                    }
                }
            }, onDismiss: {
                print("LOGIN COORDINATOR: DISMISS")
                self.rootViewController.dismiss(animated: true)
                self.applicationEvent.send(.catalogRequested)
            }
        ).environmentObject(self)
        rootViewController = UIHostingController(rootView: view)
        rootViewController.view.backgroundColor = .clear
    }
}
