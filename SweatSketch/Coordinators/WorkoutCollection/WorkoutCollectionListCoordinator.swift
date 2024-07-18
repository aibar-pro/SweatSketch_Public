//
//  WorkoutCollectionListCoordinator.swift
//  SweatSketch
//
//  Created by aibaranchikov on 15.03.2024.
//

import SwiftUI

class WorkoutCollectionListCoordinator: ObservableObject, Coordinator {
    
    let viewModel: WorkoutCollectionListViewModel
    
    var rootViewController = UIViewController()
    
    init(viewModel: WorkoutCollectionListViewModel) {
        self.viewModel = viewModel
    }
    
    func start() {
        let view = WorkoutCollectionListView(viewModel: viewModel, onSubmit: { self.saveWorkoutListChanges() }, onDiscard: { self.discardlWorkoutListChanges() })
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
