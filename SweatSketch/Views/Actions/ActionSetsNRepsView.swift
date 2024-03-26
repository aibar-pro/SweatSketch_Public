//
//  ActionSetsNRepsView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 26.03.2024.
//

import SwiftUI

struct ActionSetsNRepsView: View {
    
    @ObservedObject var actionEntity: ExerciseActionEntity
    
    var showTitle: Bool = false
    
    var body: some View {
        HStack (alignment: .top) {
            if showTitle {
                Text("\(actionEntity.name ?? Constants.Design.Placeholders.noActionName),")
            }
            
            if actionEntity.sets > 0, (actionEntity.repsMax || actionEntity.reps > 0) {
                Text("\(actionEntity.sets)x\(actionEntity.repsMax ? "MAX" : String(actionEntity.reps))")
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
        
        ActionSetsNRepsView(actionEntity: action, showTitle: true)
    }
}
