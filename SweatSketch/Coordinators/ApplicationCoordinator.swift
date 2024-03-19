//
//  ApplicationCoordinator.swift
//  SweatSketch
//
//  Created by aibaranchikov on 13.03.2024.
//

import Foundation
import UIKit
import CoreData

class ApplicationCoordinator: ObservableObject, Coordinator {

    var rootViewController: UINavigationController
    var childCoordinators = [Coordinator]()
    
    let dataContext: NSManagedObjectContext
    
    init(dataContext: NSManagedObjectContext) {
        self.rootViewController = UINavigationController()
        self.rootViewController.isNavigationBarHidden = true
        self.dataContext = dataContext
    }
    
    func start() {
        let workoutPlanningCoordinator = WorkoutCarouselCoordinator(dataContext: dataContext)
        workoutPlanningCoordinator.start()
        childCoordinators.append(workoutPlanningCoordinator)
        self.rootViewController.viewControllers = [workoutPlanningCoordinator.rootViewController]
    }
}
