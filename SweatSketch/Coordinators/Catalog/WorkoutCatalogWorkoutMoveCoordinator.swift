//
//  WorkoutCatalogWorkoutMoveCoordinator.swift
//  SweatSketch
//
//  Created by aibaranchikov on 09.04.2024.
//

import SwiftUI

class WorkoutCatalogWorkoutMoveCoordinator: ObservableObject, Coordinator {
    
    var viewModel: WorkoutCatalogWorkoutMoveViewModel
    
    var rootViewController = UIViewController()
    var childCoordinators = [Coordinator]()
    
    init(viewModel: WorkoutCatalogWorkoutMoveViewModel) {
        rootViewController = UIViewController()
        self.viewModel = viewModel
    }
    
    func start() {
        let view = WorkoutCatalogWorkoutMoveView(viewModel: self.viewModel).environmentObject(self)
        rootViewController = UIHostingController(rootView: view)
        rootViewController.view.backgroundColor = .clear
    }
    
    func saveMove(to collection: WorkoutCollectionViewRepresentation){
        if #available(iOS 15, *) {
            print("Workout Move Coordinator: Save \(Date.now)")
        } else {
            print("Workout Move Coordinator: Save")
        }
        viewModel.moveWorkout(to: collection)
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
