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
        
        var itemProgress: ItemProgress
        
        var isRest: Bool
        
        var iconName: String {
            isRest ? "leaf" : "flame"
        }
    }
}
