//
//  WorkoutListCoordinator.swift
//  SweatSketch
//
//  Created by aibaranchikov on 15.03.2024.
//

import SwiftUI

class WorkoutListCoordinator: ObservableObject, Coordinator {
    
    let viewModel: WorkoutListTemporaryViewModel
    
    var rootViewController = UIViewController()
    
    init(viewModel: WorkoutListTemporaryViewModel) {
        rootViewController = UIViewController()
        self.viewModel = viewModel
    }
    
    func start() {
        let view = WorkoutListView(viewModel: viewModel).environmentObject(self)
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
