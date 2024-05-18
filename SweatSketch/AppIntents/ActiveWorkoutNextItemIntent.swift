//
//  ActiveWorkoutNextItemIntent.swift
//  SweatSketch
//
//  Created by aibaranchikov on 20.04.2024.
//

import Foundation
import AppIntents

@available(iOS 16.1, *)
struct ActiveWorkoutNextItemIntent: LiveActivityIntent {
    
    static var title: LocalizedStringResource = "Next action"
    static var description = IntentDescription("Go to next action in active workout")
    
    func perform() async throws -> some IntentResult {
        ActiveWorkoutService.shared.nextActiveWorkoutItem()
        return .result()
    }
}
