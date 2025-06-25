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
            
            DurationPickerEditView(durationInSeconds:
                                    Binding {
                9999999
//                Int(self.actionEntity.duration)
            } set: { _ in
//                self.actionEntity.duration = Int32($0)
            }
            )
        }
    }
}

struct ActionTimedEditView_Preview : PreviewProvider {
    
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        let workoutCarouselViewModel = WorkoutCollectionViewModel(context: persistenceController.container.viewContext)
        let workoutEditViewModel = WorkoutEditorModel(parentViewModel: workoutCarouselViewModel, editingWorkoutUUID: workoutCarouselViewModel.workouts.randomElement()!.id)!
        let exerciseEditViewModel = ExerciseEditorModel(parent: workoutEditViewModel, exerciseId: workoutEditViewModel.exercises.randomElement()!.uuid!)!
        
        let appCoordinator = ApplicationCoordinator(dataContext: persistenceController.container.viewContext)
        let applicationEvent = appCoordinator.applicationEvent
        let carouselCoordinator = WorkoutCollectionCoordinator(dataContext: persistenceController.container.viewContext, applicationEvent: applicationEvent, collectionUUID: nil)
        
        let action = exerciseEditViewModel.actions.randomElement()!
        
        ActionTimedEditView(actionEntity: action, editTitle: true)
            .environmentObject(carouselCoordinator)
    }
}
