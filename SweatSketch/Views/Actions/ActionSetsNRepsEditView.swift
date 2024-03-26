//
//  ActionSetsNRepsEditView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 26.03.2024.
//

import SwiftUI

struct ActionSetsNRepsEditView: View {
    
    @ObservedObject var actionEntity: ExerciseActionEntity
    
    var editTitle: Bool = false
    
    var body: some View {
        VStack (alignment: .leading, spacing: Constants.Design.spacing/2) {
            if editTitle {
                TextField("Edit name", text: Binding(
                    get: { self.actionEntity.name ?? Constants.Design.Placeholders.noActionName },
                    set: { self.actionEntity.name = $0 }
                ))
                .padding(.horizontal, Constants.Design.spacing/2)
                .padding(.vertical, Constants.Design.spacing/2)
                .background(
                    RoundedRectangle(cornerRadius: Constants.Design.cornerRadius)
                        .stroke(Constants.Design.Colors.backgroundStartColor)
                )
            }
            
            HStack (alignment: .center, spacing: Constants.Design.spacing/4) {
                Picker("Sets", selection: Binding(
                    get: { Int(self.actionEntity.sets) },
                    set: {
                        self.actionEntity.sets = Int16($0)
                        self.actionEntity.objectWillChange.send()
                })) {
                    ForEach(1...99, id: \.self) {
                        Text("\($0)").tag($0)
                    }
                }
                .labelsHidden()
                .pickerStyle(MenuPickerStyle())
                
                Text("x")
                
                Picker("Reps", selection: Binding(
                    get: { Int(self.actionEntity.reps) },
                    set: {
                        self.actionEntity.reps = Int16($0)
                        self.actionEntity.objectWillChange.send()
                })) {
                    ForEach(1...99, id: \.self) {
                        Text("\($0)").tag($0)
                    }
                }
                .labelsHidden()
                .pickerStyle(MenuPickerStyle())
                .disabled(self.actionEntity.repsMax)
                
                Divider()
                    .fixedSize()
                
                Toggle(isOn: Binding(
                    get: { self.actionEntity.repsMax },
                    set: {
                        self.actionEntity.repsMax = $0
                        self.actionEntity.objectWillChange.send()
                })) { Text("MAX") }
                .toggleStyle(.switch)
                .labelsHidden()
                
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
        
        let action = exerciseEditViewModel.exerciseActions[2]
        
        ActionSetsNRepsEditView(actionEntity: action, editTitle: true)
        
    }
}
