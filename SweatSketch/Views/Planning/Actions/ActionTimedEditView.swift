//
//  ActionTimedEditView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 26.03.2024.
//

import SwiftUI

struct ActionTimedEditView: View {
    
    @ObservedObject var actionEntity: ExerciseActionEntity
    
    var editTitle: Bool = false
    
    var body: some View {
        VStack (alignment: .leading, spacing: Constants.Design.spacing/2) {
            if editTitle {
                TextField("Edit name", text: Binding(
                    get: { self.actionEntity.name ?? Constants.Placeholders.noActionName },
                    set: { self.actionEntity.name = $0 }
                ))
                .padding(.horizontal, Constants.Design.spacing/2)
                .padding(.vertical, Constants.Design.spacing/2)
                .background(
                    RoundedRectangle(cornerRadius: Constants.Design.cornerRadius)
                        .stroke(Constants.Design.Colors.backgroundStartColor)
                )
            }
            
            DurationPickerEditView(durationInSeconds: Binding(
                get: { Int(self.actionEntity.duration) },
                set: { self.actionEntity.duration = Int32($0) }
            ))
        }
    }
}

struct ActionTimedEditView_Preview : PreviewProvider {
    
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        let workoutCarouselViewModel = WorkoutCarouselViewModel(context: persistenceController.container.viewContext)
        let workoutEditViewModel = WorkoutEditViewModel(parentViewModel: workoutCarouselViewModel, editingWorkoutUUID: workoutCarouselViewModel.workouts[0].id)
        let exerciseEditViewModel = ExerciseEditViewModel(parentViewModel: workoutEditViewModel, editingExercise: workoutEditViewModel.exercises[2])
        
        let action = exerciseEditViewModel.exerciseActions[0]
        
        ActionTimedEditView(actionEntity: action, editTitle: true)
    }
}
