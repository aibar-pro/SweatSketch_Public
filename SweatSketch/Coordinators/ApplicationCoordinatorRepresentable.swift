//
//  ApplicationCoordinatorRepresentable.swift
//  SweatSketch
//
//  Created by aibaranchikov on 15.03.2024.
//

import Foundation
import SwiftUI
import UIKit
import CoreData

struct ApplicationCoordinatorRepresentable: UIViewControllerRepresentable {
    
    @ObservedObject var coordinator: ApplicationCoordinator
    @Environment(\.managedObjectContext) var dataContext
    @Environment(\.colorScheme) var colorScheme
    
    func makeUIViewController(context: Context) -> UINavigationController {
        coordinator.start()
//        self.setBackgroundColor()
        return coordinator.rootViewController
    }
    
    func setBackgroundColor() {
        if let window = UIApplication.shared.windows.first {
            // For some reason, it picks only light scheme color >.<
            window.backgroundColor = UIColor(.yellow)
        }
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        
    }
}
