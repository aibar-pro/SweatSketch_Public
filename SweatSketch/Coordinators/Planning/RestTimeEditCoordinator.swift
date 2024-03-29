//
//  RestTimeEditCoordinator.swift
//  SweatSketch
//
//  Created by aibaranchikov on 30.03.2024.
//

import SwiftUI

class RestTimeEditCoordinator: ObservableObject, Coordinator {
    
    var viewModel: RestTimeEditTemporaryViewModel
    
    var rootViewController = UIViewController()
    
    init(viewModel: RestTimeEditTemporaryViewModel) {
        rootViewController = UIViewController()
        self.viewModel = viewModel
    }
    
    func start() {
        let view = RestTimeEditView(viewModel: self.viewModel).environmentObject(self)
        rootViewController = UIHostingController(rootView: view)
    }
    
    func saveExerciseEdit(){
        if #available(iOS 15, *) {
            print("Exercise Coordinator: Save \(Date.now)")
        } else {
            print("Exercise Coordinator: Save")
        }
        viewModel.saveRestTime()
        rootViewController.dismiss(animated: true)
    }
    
    func discardExerciseEdit(){
        if #available(iOS 15, *) {
            print("Exercise Coordinator: Discard \(Date.now)")
        } else {
            print("Exercise Coordinator: Discard")
        }
        viewModel.discardRestTime()
        rootViewController.dismiss(animated: true)
    }
}
