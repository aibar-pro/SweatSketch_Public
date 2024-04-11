//
//  WorkoutCollectionEditCoordinator.swift
//  SweatSketch
//
//  Created by aibaranchikov on 09.04.2024.
//

import SwiftUI

class WorkoutCollectionEditCoordinator: ObservableObject, Coordinator {
    
    var viewModel: WorkoutCollectionEditViewModel
    
    var rootViewController = UIViewController()
    var childCoordinators = [Coordinator]()
    
    init(viewModel: WorkoutCollectionEditViewModel) {
        rootViewController = UIViewController()
        self.viewModel = viewModel
    }
    
    func start() {
        let view = WorkoutCollectionEditView(viewModel: self.viewModel).environmentObject(self)
        rootViewController = UIHostingController(rootView: view)
        rootViewController.view.backgroundColor = .clear
    }
    
    func saveCollection(){
        if #available(iOS 15, *) {
            print("Collection Edit Coordinator: Save \(Date.now)")
        } else {
            print("Collection Edit Coordinator: Save")
        }
        viewModel.saveCollection()
        rootViewController.dismiss(animated: true)
    }
    
    func discardCollectionEdit(){
        if #available(iOS 15, *) {
            print("Collection Edit Coordinator: Discard \(Date.now)")
        } else {
            print("Collection Edit Coordinator: Discard")
        }
        viewModel.discardCollection()
        rootViewController.dismiss(animated: true)
    }
}
