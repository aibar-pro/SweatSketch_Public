//
//  ActiveWorkoutPreviousItemIntent.swift
//  SweatSketch
//
//  Created by aibaranchikov on 24.05.2024.
//

import Foundation
import AppIntents

@available(iOS 16.1, *)
struct ActiveWorkoutPreviousItemIntent: LiveActivityIntent {
    
    static var title: LocalizedStringResource = "Previous action"
    static var description = IntentDescription("Go to previous action in active workout")
    
    func perform() async throws -> some IntentResult {
        ActiveWorkoutService.shared.previousActiveWorkoutItem()
        return .result()
    }
}
