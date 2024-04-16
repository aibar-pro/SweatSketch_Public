//
//  Constants.swift
//  SweatSketch
//
//  Created by aibaranchikov on 28.02.2024.
//

import Foundation
import SwiftUI

enum Constants {
    enum Placeholders {
        static let noCollectionName = "Untitled Collection"
        static let noWorkoutName = "Untitled Workout"
        static let noExerciseName = "Untitled Exercise"
        static let noActionName = "Untitled Action"
        static let noRestTimeName = "Untitled Rest Period"
        
        static let noExerciseDetails = "No Exercise details"
        static let noActionDetails = "No Action details"
        
        static let noDuration = "-:-:-"
        
        static let restPeriodLabel = "Rest Time"
        
        static let activeWorkoutItemError = "Error fetching workout item"
    }
    
    enum Design {
        static let cornerRadius = CGFloat(16)
        static let spacing = CGFloat(20)
        
        enum Colors {
            static let backgroundStartColor = Color(.backgroundGradientStart).opacity(0.87)
            static let backgroundEndColor = Color(.backgroundGradientEnd).opacity(0.87)
            static let backgroundAccentColor = Color(.backgroundAccent).opacity(0.87)
            static let buttonAccentBackgroundColor = Color(.accent).opacity(0.87)
            static let buttonPrimaryBackgroundColor = Color(.backgroundGradientStart).opacity(0.87)
            static let buttonSecondaryBackgroundColor = Color.secondary.opacity(0.05)
            static let textColorHighEmphasis = Color.primary.opacity(0.87)
            static let textColorMediumEmphasis = Color.primary.opacity(0.6)
        }
    }
    
    enum DefaultValues {
        static let defaultWorkoutCollectionName = "Default Collection"
        static let importedWorkoutCollectionName = "Imported Workouts"
        
        static let setsCount = 1
        static let repsCount = 1
        static let actionDuration = 30
        static let supersetCount = 1
        static let restTimeDuration = 60
    }
}
