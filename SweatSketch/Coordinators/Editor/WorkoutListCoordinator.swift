//
//  WorkoutListCoordinator.swift
//  SweatSketch
//
//  Created by aibaranchikov on 15.03.2024.
//

import SwiftUI

class WorkoutListCoordinator: ObservableObject, Coordinator {
    
    let viewModel: WorkoutListViewModel
    
    var rootViewController = UIViewController()
    
    init(viewModel: WorkoutListViewModel) {
        rootViewController = UIViewController()
        self.viewModel = viewModel
    }
    
    func start() {
        let view = WorkoutListView(viewModel: viewModel, onSubmit: { self.saveWorkoutListChanges() }, onDiscard: { self.discardlWorkoutListChanges() })
        rootViewController = UIHostingController(rootView: view)
    }
    
    func saveWorkoutListChanges(){
        viewModel.saveWorkoutListChange()
        if #available(iOS 15, *) {
            print("List Save \(Date.now)")
        } else {
            print("List Save")
        }
        rootViewController.dismiss(animated: true)
    }
    
    func discardlWorkoutListChanges(){
        viewModel.discardWorkoutListChange()
        if #available(iOS 15, *) {
            print("List Discard \(Date.now)")
        } else {
            print("List Discard")
        }
        rootViewController.dismiss(animated: true)
    }
}
