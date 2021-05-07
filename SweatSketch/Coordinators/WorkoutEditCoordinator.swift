//
//  WorkoutEditCoordinators.swift
//  SweatSketch
//
//  Created by aibaranchikov on 15.03.2024.
//

import Foundation
import SwiftUI

class WorkoutEditCoordinator: ObservableObject, Coordinator {
    
    @Published var viewModel: WorkoutEditTemporaryViewModel
    
    var rootViewController = UIViewController()
    
    init(viewModel: WorkoutEditTemporaryViewModel) {
        rootViewController = UIViewController()
        self.viewModel = viewModel
    }
    
    func start() {
        let view = WorkoutEditView().environmentObject(self)
        rootViewController = UIHostingController(rootView: view)
    }
    
    func saveWorkoutEdit(){
        if #available(iOS 15, *) {
            print("Workout Dismiss:Save \(Date.now)")
        } else {
            print("Workout Dismiss:Save")
        }
        viewModel.saveWorkout()
        rootViewController.navigationController?.popViewController(animated: true)
    }
    
    func discardWorkoutEdit(){
        if #available(iOS 15, *) {
            print("Workout Dismiss:Discard \(Date.now)")
        } else {
            print("Workout Dismiss:Discard")
        }
        viewModel.cancelWorkoutEdit()
        rootViewController.navigationController?.popViewController(animated: true)
    }
}
