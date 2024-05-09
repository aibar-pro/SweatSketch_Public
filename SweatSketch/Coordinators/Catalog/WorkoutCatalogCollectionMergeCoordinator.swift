//
//  WorkoutCatalogCollectionMergeCoordinator.swift
//  SweatSketch
//
//  Created by aibaranchikov on 13.04.2024.
//

import SwiftUI

class WorkoutCatalogCollectionMergeCoordinator: ObservableObject, Coordinator {
    
    var viewModel: WorkoutCatalogCollectionMergeViewModel
    
    var rootViewController = UIViewController()
    var childCoordinators = [Coordinator]()
    
    init(viewModel: WorkoutCatalogCollectionMergeViewModel) {
        rootViewController = UIViewController()
        self.viewModel = viewModel
    }
    
    func start() {
        let view = WorkoutCatalogCollectionMergeView(viewModel: self.viewModel).environmentObject(self)
        rootViewController = UIHostingController(rootView: view)
        rootViewController.view.backgroundColor = .clear
    }
    
    func saveMove(to collection: WorkoutCollectionViewRepresentation){
        if #available(iOS 15, *) {
            print("Workout Move Coordinator: Save \(Date.now)")
        } else {
            print("Workout Move Coordinator: Save")
        }
        viewModel.mergeCollections(to: collection)
        rootViewController.dismiss(animated: true)
    }
    
    func discardMove(){
        if #available(iOS 15, *) {
            print("Workout Move Coordinator: Discard \(Date.now)")
        } else {
            print("Workout Move Coordinator: Discard")
        }
        viewModel.discardMerge()
        rootViewController.dismiss(animated: true)
    }
}
