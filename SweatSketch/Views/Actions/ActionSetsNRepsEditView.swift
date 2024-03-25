//
//  ActionSetsNRepsEditView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 26.03.2024.
//

import SwiftUI

struct ActionSetsNRepsEditView: View {
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
            
            HStack (alignment: .center, spacing: Constants.Design.spacing/2) {
                Picker("Sets", selection: Binding(
                    get: { Int(self.exerciseAction.sets) },
                    set: { self.exerciseAction.sets = Int16($0) }
                )) {
                    ForEach(1...99, id: \.self) {
                        Text("\($0)").tag($0)
                    }
                }
                .labelsHidden()
                .pickerStyle(MenuPickerStyle())
                .fixedSize()
                Text("x")
                Picker("Reps", selection: Binding(
                    get: { Int(self.exerciseAction.reps) },
                    set: { self.exerciseAction.reps = Int16($0) }
                )) {
                    ForEach(1...99, id: \.self) {
                        Text("\($0)").tag($0)
                    }
                }
                .labelsHidden()
                .pickerStyle(MenuPickerStyle())
                .fixedSize()
                .disabled(self.exerciseAction.repsMax)
                Divider()
                    .fixedSize()
                Toggle(isOn: Binding(
                    get: { self.exerciseAction.repsMax },
                    set: { self.exerciseAction.repsMax = $0 }
                )) {
                    Text("MAX")
                }
                .toggleStyle(.switch)
                .labelsHidden()
                .fixedSize()
                Text("MAX")
                    .padding(Constants.Design.spacing/2)
            }
        }
    }
}

struct ActionSetsNRepsEditView_Previews: PreviewProvider {

    static var previews: some View {
        let persistenceController = PersistenceController.preview
        let workoutCarouselViewModel = WorkoutCarouselViewModel(context: persistenceController.container.viewContext)
        let workoutEditViewModel = WorkoutEditTemporaryViewModel(parentViewModel: workoutCarouselViewModel, editingWorkout: workoutCarouselViewModel.workouts[0])
        let exerciseEditViewModel = ExerciseEditTemporaryViewModel(parentViewModel: workoutEditViewModel, editingExercise: workoutEditViewModel.exercises[2])
        
        let action = exerciseEditViewModel.exerciseActions[1]
        
        ActionSetsNRepsEditView(exerciseAction: action, editTitle: true)
    }
}
