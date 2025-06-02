//
//  Coordinator.swift
//  SweatSketch
//
//  Created by aibaranchikov on 13.03.2024.
//

import Foundation
import SwiftUI

protocol Coordinator {
    func start()
}

class BaseCoordinator<VM>: ObservableObject {
    var viewModel: VM

    var rootViewController = UIViewController()
    var childCoordinators = [Coordinator]()

    init(viewModel: VM) {
        self.viewModel = viewModel
    }
    
    func addViewPushTransition(pushDirection: CATransitionSubtype) {
        rootViewController.navigationController?.view.layer.add(CATransition.push(pushDirection), forKey: kCATransition)
    }
    
    func addViewFadeTransition() {
        rootViewController.navigationController?.view.layer.add(CATransition.fade(), forKey: kCATransition)
    }
}
