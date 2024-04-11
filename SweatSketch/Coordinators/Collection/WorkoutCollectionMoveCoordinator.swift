//
//  WorkoutCollectionMoveCoordinator.swift
//  SweatSketch
//
//  Created by aibaranchikov on 13.04.2024.
//

import SwiftUI

class WorkoutCollectionMoveCoordinator: ObservableObject, Coordinator {
    
    var viewModel: WorkoutCollectionMoveViewModel
    
    var rootViewController = UIViewController()
    var childCoordinators = [Coordinator]()
    
    init(viewModel: WorkoutCollectionMoveViewModel) {
        rootViewController = UIViewController()
        self.viewModel = viewModel
    }
    
    func start() {
//        let view = WorkoutCollectionWorkoutMoveView(viewModel: self.viewModel).environmentObject(self)
//        rootViewController = UIHostingController(rootView: view)
//        rootViewController.view.backgroundColor = .clear
    }
    
    func saveMove(to collection: WorkoutCollectionViewRepresentation? = nil){
        if #available(iOS 15, *) {
            print("Workout Move Coordinator: Save \(Date.now)")
        } else {
            print("Workout Move Coordinator: Save")
        }
        viewModel.moveCollection(to: collection)
        rootViewController.dismiss(animated: true)
    }
    
    func discardMove(){
        if #available(iOS 15, *) {
            print("Workout Move Coordinator: Discard \(Date.now)")
        } else {
            print("Workout Move Coordinator: Discard")
        }
        viewModel.discardMove()
        rootViewController.dismiss(animated: true)
    }
}
