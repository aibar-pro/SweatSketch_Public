//
//  ActiveWorkoutActionAttributes.swift
//  SweatSketch
//
//  Created by aibaranchikov on 17.04.2024.
//

import ActivityKit
import Foundation

typealias ActiveWorkoutActivityState = ActiveWorkoutActionAttributes.ActiveWorkoutActionStatus

struct ActiveWorkoutActionAttributes: ActivityAttributes {
    public typealias ActiveWorkoutActionStatus = ContentState
    
    public struct ContentState: Codable, Hashable {
        var actionID: UUID?
        var title: String
        var quantity: String
        var progress: Double
        var isRest: Bool
        var stepIndex: Int
        var totalSteps: Int
        
        var iconName: String {
            isRest ? "leaf" : "flame"
        }
    }
}
