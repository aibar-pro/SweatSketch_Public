//
//  ActiveWorkoutActionAttributes.swift
//  SweatSketch
//
//  Created by aibaranchikov on 17.04.2024.
//

import ActivityKit
import Foundation

struct ActiveWorkoutActionAttributes: ActivityAttributes {
    public typealias ActiveWorkoutActionStatus = ContentState
    
    public struct ContentState: Codable, Hashable {
        var actionID: UUID?
        var title: String
        var repsCount: Int16?
        var repsMax: Bool?
        var duration: Int?
        var totalActions: Int
        var currentAction: Int
        
        var iconName: String {
            if duration != nil {
                return "gauge.with.needle"
            } else if repsMax != nil  || repsCount != nil {
                return "123.rectangle"
            }
            else {
                return "questionmark.circle"
            }
        }
    }
}
