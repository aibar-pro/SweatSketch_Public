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
    var editSets: Bool = true
    
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
            
            HStack (alignment: .center, spacing: Constants.Design.spacing/4) {
                if editSets {
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
                }
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
                    })) { Text(Constants.Placeholders.maximumRepetitionsLabel) }
                .toggleStyle(.switch)
                .labelsHidden()
                
                Text(Constants.Placeholders.maximumRepetitionsLabel)
                .padding(Constants.Design.spacing/2)
            }
        }
    }
}

struct ActionSetsNRepsEditView_Previews: PreviewProvider {

    static var previews: some View {
        let persistenceController = PersistenceController.preview
        
        let collectionDataManager = CollectionDataManager()
        let firstCollection = collectionDataManager.fetchFirstUserCollection(in: persistenceController.container.viewContext)!
        let workoutForPreview = collectionDataManager.fetchWorkouts(for: firstCollection, in: persistenceController.container.viewContext).first!
        
        let workoutDataManager = WorkoutDataManager()
        
        let exerciseForPreview = workoutDataManager.fetchExercises(for: workoutForPreview, in: persistenceController.container.viewContext)[1]
        
        let exerciseDataManager = ExerciseDataManager()
        
        let actionForPreview = exerciseDataManager.fetchActions(for: exerciseForPreview, in: persistenceController.container.viewContext)[0]
        
        VStack (spacing: 50) {
            ActionSetsNRepsEditView(actionEntity: actionForPreview, editTitle: true)
            
            ActionSetsNRepsEditView(actionEntity: actionForPreview, editSets: false)
        }
        
    }
}
