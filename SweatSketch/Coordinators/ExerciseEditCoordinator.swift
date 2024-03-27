//
//  ExerciseEditCoordinator.swift
//  SweatSketch
//
//  Created by aibaranchikov on 20.03.2024.
//

import Foundation
import SwiftUI

class ExerciseEditCoordinator: ObservableObject, Coordinator {
    
    var viewModel: ExerciseEditTemporaryViewModel
    
    var rootViewController = UIViewController()
    
    init(viewModel: ExerciseEditTemporaryViewModel) {
        rootViewController = UIViewController()
        self.viewModel = viewModel
    }
    
    func start() {
        let view = ExerciseEditView(viewModel: self.viewModel).environmentObject(self)
        rootViewController = UIHostingController(rootView: view)
        //TODO: fix dark theme background in preview
    }
    
    func saveExerciseEdit(){
        if #available(iOS 15, *) {
            print("Exercise Coordinator: Save \(Date.now)")
        } else {
            print("Exercise Coordinator: Save")
        }
        
        viewModel.saveFilteredExerciseActions()
        viewModel.saveExercise()
        rootViewController.dismiss(animated: true)
//        rootViewController.navigationController?.popViewController(animated: true)
    }
    
    func discardExerciseEdit(){
        if #available(iOS 15, *) {
            print("Exercise Coordinator: Discard \(Date.now)")
        } else {
            print("Exercise Coordinator: Discard")
        }
        viewModel.discardExercise()
        rootViewController.dismiss(animated: true)
//        rootViewController.navigationController?.popViewController(animated: true)
    }
}
