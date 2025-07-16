//
//  BaseCoordinator.swift
//  SweatSketch
//
//  Created by aibaranchikov on 18.06.2025.
//

import SwiftUI

class BaseCoordinator: ObservableObject {
    var rootViewController = UIViewController()
    var childCoordinators = [Coordinator]()

    init() {}
    
    func addViewPushTransition(pushDirection: CATransitionSubtype) {
        rootViewController.navigationController?.view.layer.add(CATransition.push(pushDirection), forKey: kCATransition)
    }
    
    func addViewFadeTransition() {
        rootViewController.navigationController?.view.layer.add(CATransition.fade(), forKey: kCATransition)
    }
    
    func presentBottomSheet(type: BottomSheetType) {
        addViewFadeTransition()
        
        let view = BottomSheetView(
            onDismiss: {
                type.cancelAction?()
                self.dismissBottomSheet()
            },
            content: {
                type.view(
                    onDismiss: {
                        self.dismissBottomSheet()
                    }
                )
            }
        )
        .environmentObject(self)
        
        let bottomSheetVC = UIHostingController(rootView: view)
        bottomSheetVC.view.backgroundColor = .clear
        bottomSheetVC.modalPresentationStyle = .overFullScreen
        rootViewController.present(bottomSheetVC, animated: false)
    }
    
    func dismissBottomSheet() {
        addViewFadeTransition()
        rootViewController.dismiss(animated: false)
    }
}
