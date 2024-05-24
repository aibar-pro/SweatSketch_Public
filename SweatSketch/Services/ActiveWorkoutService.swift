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

    func nextActiveWorkoutItem() {
        workoutManager?.nextActiveWorkoutItem()
    }
    
    func previousActiveWorkoutItem() {
        workoutManager?.previousActiveWorkoutItem()
    }
}
