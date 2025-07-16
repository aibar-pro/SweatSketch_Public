//
//  ActiveWorkoutService.swift
//  SweatSketch
//
//  Created by aibaranchikov on 24.05.2024.
//

import Foundation

class ActiveWorkoutService: ActiveWorkoutManagementProtocol {
    static let shared = ActiveWorkoutService()
    private init() {}

    var workoutManager: ActiveWorkoutManagementProtocol?

    func nextWorkoutStep() {
        workoutManager?.nextWorkoutStep()
    }
    
    func previousWorkoutStep() {
        workoutManager?.previousWorkoutStep()
    }
}
