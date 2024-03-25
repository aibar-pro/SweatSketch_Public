//
//  ActionSetsNRepsView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 26.03.2024.
//

import SwiftUI

struct ActionSetsNRepsView: View {
    
    @ObservedObject var exerciseAction: ExerciseActionEntity
    
    var showTitle: Bool = false
    
    var body: some View {
        HStack (alignment: .top) {
            if showTitle {
                Text("\(exerciseAction.name ?? Constants.Design.Placeholders.noActionName),")
            }
            
            if exerciseAction.sets > 0, (exerciseAction.repsMax || exerciseAction.reps > 0) {
                Text("\(exerciseAction.sets)x\(exerciseAction.repsMax ? "MAX" : String(exerciseAction.reps))")
            } else {
                Text(Constants.Design.Placeholders.noActionDetails)
            }
        }
    }
}

struct ActionSetsNRepsView_Previews: PreviewProvider {

    static var previews: some View {
        let persistenceController = PersistenceController.preview
        let workoutCarouselViewModel = WorkoutCarouselViewModel(context: persistenceController.container.viewContext)
        let workoutEditViewModel = WorkoutEditTemporaryViewModel(parentViewModel: workoutCarouselViewModel, editingWorkout: workoutCarouselViewModel.workouts[0])
        let exerciseEditViewModel = ExerciseEditTemporaryViewModel(parentViewModel: workoutEditViewModel, editingExercise: workoutEditViewModel.exercises[2])
        
        let action = exerciseEditViewModel.exerciseActions[1]
        
        ActionSetsNRepsView(exerciseAction: action, showTitle: true)
    }
}
