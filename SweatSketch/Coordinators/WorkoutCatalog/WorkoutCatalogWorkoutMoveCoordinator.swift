//
//  WorkoutCatalogWorkoutMoveCoordinator.swift
//  SweatSketch
//
//  Created by aibaranchikov on 09.04.2024.
//

import SwiftUI

class WorkoutCatalogWorkoutMoveCoordinator: BaseCoordinator, Coordinator {
    let viewModel: WorkoutCatalogWorkoutMoveViewModel
    
    init(viewModel: WorkoutCatalogWorkoutMoveViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    func start() {
        let view = WorkoutCatalogWorkoutMoveView(viewModel: self.viewModel).environmentObject(self)
        rootViewController = UIHostingController(rootView: view)
        rootViewController.view.backgroundColor = .clear
    }
    
    func saveMove(to collection: CollectionRepresentation){
        print("\(type(of: self)): Workouts moved, saving... \(Date())")
        viewModel.moveWorkout(to: collection)
        rootViewController.dismiss(animated: true)
    }
    
    func discardMove(){
        print("\(type(of: self)): Workouts moved, saving... \(Date())")
        viewModel.discardMove()
        rootViewController.dismiss(animated: true)
    }
}
