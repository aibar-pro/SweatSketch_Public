//
//  ActionTimedEditView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 26.03.2024.
//

import SwiftUI

struct ActionTimedEditView: View {
    @ObservedObject var exerciseAction: ExerciseActionEntity
    
    var editTitle: Bool = false
    
    var body: some View {
        VStack (alignment: .leading, spacing: Constants.Design.spacing/2) {
            if editTitle {
                TextField("Edit name", text: Binding(
                    get: { self.exerciseAction.name ?? Constants.Design.Placeholders.noActionName },
                    set: { self.exerciseAction.name = $0 }
                ))
                .padding(.horizontal, Constants.Design.spacing/2)
                .padding(.vertical, Constants.Design.spacing/2)
                .background(
                    RoundedRectangle(cornerRadius: Constants.Design.cornerRadius)
                        .stroke(Constants.Design.Colors.backgroundStartColor)
                )
            }
            
            DurationPickerEditView(durationInSeconds: Binding(
                get: { Int(self.exerciseAction.duration) },
                set: { self.exerciseAction.duration = Int32($0) }
            ))
        }
    }
}

struct ActionTimedEditView_Preview : PreviewProvider {
   
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        let workoutCarouselViewModel = WorkoutCarouselViewModel(context: persistenceController.container.viewContext)
        let workoutEditViewModel = WorkoutEditTemporaryViewModel(parentViewModel: workoutCarouselViewModel, editingWorkout: workoutCarouselViewModel.workouts[0])
        let exerciseEditViewModel = ExerciseEditTemporaryViewModel(parentViewModel: workoutEditViewModel, editingExercise: workoutEditViewModel.exercises[2])
        
        let action = exerciseEditViewModel.exerciseActions[0]
        
        ActionTimedEditView(exerciseAction: action, editTitle: true)
    }
}
