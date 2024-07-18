//
//  RestTimeEditCoordinator.swift
//  SweatSketch
//
//  Created by aibaranchikov on 30.03.2024.
//

import SwiftUI

class RestTimeEditCoordinator: ObservableObject, Coordinator {
    
    var viewModel: RestTimeEditViewModel
    
    var rootViewController = UIViewController()
    
    init(viewModel: RestTimeEditViewModel) {
        self.viewModel = viewModel
    }
    
    func start() {
        let view = RestTimeEditView(viewModel: self.viewModel).environmentObject(self)
        rootViewController = UIHostingController(rootView: view)
    }
    

    func saveRestTimeEdit(){
        if #available(iOS 15, *) {
            print("Rest Time Coordinator: Save \(Date.now)")
        } else {
            print("Rest Time Coordinator: Save")
        }
        viewModel.saveRestTime()
        rootViewController.dismiss(animated: true)
    }
    
    func discardRestTimeEdit(){
        if #available(iOS 15, *) {
            print("Rest Time Coordinator: Discard \(Date.now)")
        } else {
            print("Rest Time Coordinator: Discard")
        }
        viewModel.cancelRestTime()
        rootViewController.dismiss(animated: true)
    }
}
