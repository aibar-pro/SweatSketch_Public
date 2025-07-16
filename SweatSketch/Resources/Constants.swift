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
        static let loaderText = String.localized("Loading...")
        
        static let noCollectionName = String.localized("Untitled Collection")
        static let noWorkoutName = String.localized("Untitled Workout")
        static let noExerciseName = String.localized("Untitled Exercise")
        static let noActionName = String.localized("Untitled Action")
        static let noRestTimeName = String.localized("Untitled Rest Period")
        
        static let noExerciseDetails = String.localized("No Exercise details")
        static let noActionDetails = String.localized("No Action details")
        
        static let noDuration = String.localized("-:-:-")
        
        static let restPeriodLabel = String.localized("Rest Time")
        
        static let activeWorkoutItemError = String.localized("Error fetching workout item")
        
        static let workoutSummaryTitle = String.localized("Workout Complete!")
        
        enum WorkoutCatalog {
            static let userLoggedInLabel = String.localized("User")
   
            static let addCollectionPopupTitle = String.localized("Add Collection")
            static let addCollectionPopupText = String.localized("Enter collection name")
            static let addCollectionPopupButtonLabel = String.localized("Add")
            
            static let moveDestinationText = String.localized("Select a destination")
            static let moveTopDestinationText = String.localized("To the top")
            
            static let mergeDestinationText = String.localized("Move all workouts to")
        }
        
        enum WorkoutCollection {
            static let toCatalogButtonLabel = String.localized("Catalog")
            
            static let editWorkoutButtonLabel = String.localized("Edit Workout")
            static let listWorkoutButtonLabel = String.localized("Reorder or delete workouts")
            
            static let startWorkoutButtonLabel = String.localized("Go")
            
            static let emptyCollectionText = String.localized("Empty Collection")
            static let emptyCollectionButtonLabel = String.localized("Add Workout")
            
            static let workoutListTitle = String.localized("Workouts")
            
            static let supersetCountLabel = String.localized("Superset repetitions")
            static let actionTypeLabel = String.localized("Action type")
            
            static let defaultRestTimeTitle = String.localized("Default Rest Time")
            static let defaultRestTimeLabel = String.localized("Default Rest Time:")
            static let customRestTimeText = String.localized("Advanced edit")
            static let customRestTimeAddButtonLabel = String.localized("Customize")
            
            static let exerciseRestTimeLabel = String.localized("Rest Time between actions")
        }
        
        enum ActiveWorkout {
            static let toActiveItemLabel = String.localized("Active item")
            static let summaryConfirmationButtonLabel = String.localized("Proceed")
        }
        
        enum UserProfile {
            static let profileButtonLabel = String.localized("Profile")
            
            static let logoutButtonLabel = String.localized("Logout")
            
            static let noUsername = String.localized("Champion")
            
            static let greetingLabel = String.localized("Hello")
        }

        static let renamePopupText = String.localized("Enter new name")
        static let renamePopupButtonLabel = String.localized("Rename")
        
        static let maximumRepetitionsLabel = String.localized("MAX")
        
        static let secondsLabel = String.localized("seconds")
        
        static let emailLabel = String.localized("Email")
        static let passwordLabel = String.localized("Password")
        
        enum ExerciseTypes {
            static let setsNreps = String.localized("Sets-n-reps")
            static let timed = String.localized("Timed")
            static let mixed = String.localized("Mixed")
            static let unknown = String.localized("Unknown")
        }
        
        enum ExerciseActionTypes {
            static let setsNreps = String.localized("Sets and reps")
            static let timed = String.localized("Timed")
            static let unknown = String.localized("Unknown")
        }
        
    }
    
    enum Data {
        static let undoLevelsLimit: Int = 15
    }
    
    enum Design {
        static let cornerRadius = CGFloat(16)
        static let spacing = CGFloat(20)
        static let buttonLabelPaddding: CGFloat = 12
        
        enum Colors {
            static let screenBgStart = Color.bgGradientStart.opacity(0.87)
            static let screenBgEnd = Color.bgGradientEnd.opacity(0.87)
            static let screenBgAccent = Color.bgAccent.opacity(0.87)

            static let elementBgAccent = Color.accent.opacity(0.87)
            static let elementBgPrimary = Color.bgGradientStart.opacity(0.87)
            static let elementBgSecondary = Color.bgSecondaryElement.opacity(0.87)

            static let elementFgAccent = Color.accent.opacity(0.87)
            static let elementFgPrimary = Color.bgGradientStart.opacity(0.87)
            static let elementFgHighEmphasis = Color.primary.opacity(0.87)
            static let elementFgMediumEmphasis = Color.primary.opacity(0.6)
            static let elementFgLowEmphasis = Color.primary.opacity(0.1)
            static let elementFgLink = Color.fgLink.opacity(0.87)
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
        
        enum UserProfile {
            static let username = Constants.Placeholders.UserProfile.noUsername
            static let age = 18
            static let ageRange: ClosedRange<Int> = 0...200
            static let height = 100.0
            static let heightRange: ClosedRange<Double> = 0...200
            static let weight = 50.0
            static let weightRange: ClosedRange<Double> = 0...500
        }
    }
}
