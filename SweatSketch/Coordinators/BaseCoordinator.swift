//
//  BaseCoordinator.swift
//  SweatSketch
//
//  Created by aibaranchikov on 18.06.2025.
//

import SwiftUI

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
    
    func presentBottomSheet(
        type: BottomSheetType,
        action: @escaping () -> Void,
        cancel: @escaping () -> Void
    ) {
        addViewFadeTransition()
        let view = Button("Test"){ action() }.environmentObject(self)
        let bottomSheetVC = UIHostingController(rootView: view)
        rootViewController.navigationController?.pushViewController(bottomSheetVC, animated: false)
    }
}

enum BottomSheetType {
    case rename(action: () -> Void, cancel: () -> Void)
    case delete(action: () -> Void, cancel: () -> Void)
}
