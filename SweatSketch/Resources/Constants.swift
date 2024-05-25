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
        
        static let workoutSummaryTitle = "Workout Complete!"
        
        enum WorkoutCatalog {
            static let title = "Workout Catalog"
            static let userLoggedInLabel = "User"
            static let renameCollectionButtonLabel = "Rename Collection"
            static let moveCollectionButtonLabel = "Move Collection"
            static let mergeCollectionButtonLabel = "Merge Collection"
            
            static let moveWorkoutButtonLabel = "Move Workout"
            static let shareWorkoutButtonLabel = "Share Workout"
            
            static let addCollectionPopupTitle = "Add Collection"
            static let addCollectionPopupText = "Enter collection name"
            static let addCollectionPopupButtonLabel = "Add"
            
            static let moveDestinationText = "Select a destination"
            static let moveTopDestinationText = "To the top"
            
            static let mergeDestinationText = "Move all workouts to"
        }
        
        enum WorkoutCollection {
            static let toCatalogButtonLabel = "Catalog"
            
            static let editWorkoutButonLabel = "Edit Workout"
            static let listWorkoutButonLabel = "Reorder or delete workouts"
            
            static let startWorkoutButtonLabel = "Go"
            
            static let emptyCollectionText = "Empty Collection"
            static let emptyCollectionButtonLabel = "Add Workout"
            
            static let workoutListTitle = "Workouts"
            
            static let emptyWorkoutText = "No Exercises yet"
            
            static let renameWorkoutPopupTitle = "Rename Workout"
            static let renameExercisePopupTitle = "Rename Exercise"
            
            static let supersetCountLabel = "Superset repetitions"
            static let actionTypeLabel = "Action type"
            
            static let defaultRestTimeTitle = "Default Rest Time"
            static let defaultRestTimeLabel = "Default Rest Time:"
            static let customRestTimeText = "Advanced edit"
            static let customRestTimeAddButtonLabel = "Customize"
            
            static let exerciseRestTimeLabel = "Rest Time between actions"
        }
        
        enum ActiveWorkout {
            static let toActiveItemLabel = "Active item"
            static let summaryConfirmationButtonLable = "Proceed"
        }
        
        enum UserProfile {
            static let loginButtonLabel = "Login"
            
            static let loginScreenTitle = "Welcome Back!"
            static let loginScreenText = "Login to your account"
            
            static let signupLinkText = "Don't have an account?"
            
            static let signupButtonLabel = "Sign Up"
        }
        
        static let saveButtonLabel = "Save"
        static let doneButtonLabel = "Done"
        static let cancelButtonLabel = "Cancel"
        
        static let renamePopupText = "Enter new name"
        static let renamePopupButtonLabel = "Rename"
        
        static let maximumRepetitionsLabel = "MAX"
        
        static let secondsLabel = "seconds"
        
        static let emailLabel = "Email"
        static let passwordLabel = "Password"
        
        enum ExerciseTypes {
            static let setsNreps = "Sets-n-reps"
            static let timed = "Timed"
            static let mixed = "Mixed"
            static let unknown = "Unknown"
        }
        
        enum ExerciseActionTypes {
            static let setsNreps = "Sets and reps"
            static let timed = "Timed"
            static let unknown = "Unknown"
        }
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
            static let textColorlowEmphasis = Color.primary.opacity(0.1)
            static let linkColor = Color(.link).opacity(0.87)
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
