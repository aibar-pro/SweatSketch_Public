//
//  WorkoutListCoordinator.swift
//  SweatSketch
//
//  Created by aibaranchikov on 15.03.2024.
//

import Foundation
import SwiftUI

class WorkoutListCoordinator: ObservableObject, Coordinator {
    
    @Published var viewModel: WorkoutListTemporaryViewModel
    
    var rootViewController = UIViewController()
    
    init(viewModel: WorkoutListTemporaryViewModel) {
        rootViewController = UIViewController()
        self.viewModel = viewModel
    }
    
    func start() {
        let view = WorkoutListView().environmentObject(self)
        rootViewController = UIHostingController(rootView: view)
    }
    
    func saveWorkoutListChanges(){
        viewModel.saveWorkoutListChange()
        if #available(iOS 15, *) {
            print("List Dismiss:Save \(Date.now)")
        } else {
            print("List Dismiss:Save")
        }
        rootViewController.dismiss(animated: true)
    }
    
    func discardlWorkoutListChanges(){
        viewModel.cancelWorkoutListChange()
        if #available(iOS 15, *) {
            print("List Dismiss:Discard \(Date.now)")
        } else {
            print("List Dismiss:Discard")
        }
        rootViewController.dismiss(animated: true)
    }
}
