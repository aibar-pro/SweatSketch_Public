//
//  UserProfileViewCoordinator.swift
//  SweatSketch
//
//  Created by aibaranchikov on 27.06.2024.
//

import Foundation
import UIKit
import SwiftUI

class UserProfileViewCoordinator: Coordinator {
    var viewModel: UserProfileViewModel
    
    var rootViewController = UIViewController()
    weak var delegate: UserProfileCoordinatorDelegate?
    
    init() {
        viewModel = UserProfileViewModel()
    }

    func start() {
        let userProfileView = UserProfileView(
            onSubmit: { [weak self] userProfile in
                self?.delegate?.didRequestProfileUpdate(userProfile: userProfile)
            },
            onDismiss: { [weak self] in
                self?.delegate?.didRequestReturn()
            },
            onLogout: { [weak self] in
                self?.delegate?.didRequestLogout()
            },
            viewModel: viewModel
        )
        let userProfileViewController = UIHostingController(rootView: userProfileView)
        rootViewController = userProfileViewController
        rootViewController.view.backgroundColor = .clear
      }
}
