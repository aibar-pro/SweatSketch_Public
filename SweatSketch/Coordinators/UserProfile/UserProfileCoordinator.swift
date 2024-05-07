//
//  UserProfileCoordinator.swift
//  SweatSketch
//
//  Created by aibaranchikov on 09.05.2024.
//

import SwiftUI
import Combine

class UserProfileCoordinator: ObservableObject, Coordinator {
//    var viewModel: WorkoutCollectionMoveViewModel
    
    var rootViewController = UIViewController()
    var childCoordinators = [Coordinator]()
    
    let applicationEvent: PassthroughSubject<ApplicationEventType, Never>
    
//    init(viewModel: WorkoutCollectionMoveViewModel) {
    init (applicationEvent: PassthroughSubject<ApplicationEventType, Never>) {
        rootViewController = UIViewController()
        self.applicationEvent = applicationEvent
//        self.viewModel = viewModel
    }
    
    func start() {
        let view = UserProfileLoginView(onLogin: {
                print("LOGIN COORDINATOR: LOGIN")
                self.rootViewController.dismiss(animated: true)
                self.applicationEvent.send(.catalogRequested)
            }, onDismiss: {
                print("LOGIN COORDINATOR: DISMISS")
                self.rootViewController.dismiss(animated: true)
                self.applicationEvent.send(.catalogRequested)
            }
        ).environmentObject(self)
        rootViewController = UIHostingController(rootView: view)
        rootViewController.view.backgroundColor = .clear
    }
    
//    func saveMove(to collection: WorkoutCollectionViewRepresentation? = nil){
//        if #available(iOS 15, *) {
//            print("Workout Move Coordinator: Save \(Date.now)")
//        } else {
//            print("Workout Move Coordinator: Save")
//        }
//        viewModel.moveCollection(to: collection)
//        rootViewController.dismiss(animated: true)
//    }
//    
//    func discardMove(){
//        if #available(iOS 15, *) {
//            print("Workout Move Coordinator: Discard \(Date.now)")
//        } else {
//            print("Workout Move Coordinator: Discard")
//        }
//        viewModel.discardMove()
//        rootViewController.dismiss(animated: true)
//    }
}
