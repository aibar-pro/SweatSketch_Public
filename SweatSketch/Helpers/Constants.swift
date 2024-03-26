//
//  Constants.swift
//  SweatSketch
//
//  Created by aibaranchikov on 28.02.2024.
//

import Foundation
import SwiftUI

enum Constants {
    enum Design {

        static let cornerRadius = CGFloat(16)
        static let spacing = CGFloat(20)
        
        enum Colors {
            static let backgroundStartColor = Color("background_gradient_start").opacity(0.7)
            static let backgroundEndColor = Color("background_gradient_end").opacity(0.7)
            static let buttonBackgroundColor = Color("button_background")
        }
        
        enum Placeholders {
            static let noWorkoutName = "Untitled Workout"
            static let noExerciseName = "Untitled Exercise"
            static let noActionName = "Untitled Action"
            
            static let noExerciseDetails = "No Exercise details"
            static let noActionDetails = "No Action details"
        }
    }
    
    
}