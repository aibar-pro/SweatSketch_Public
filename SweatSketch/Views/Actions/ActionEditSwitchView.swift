//
//  ExerciseItemView.swift
//  MyWorkoutPlanner
//
//  Created by aibaranchikov on 7/5/21.
//

import SwiftUI

struct ActionEditSwitchView: View {
    
    @ObservedObject var actionEntity: ExerciseActionEntity
    
    @Binding var isEditing: Bool
    
    var exerciseType: ExerciseType
    
    var onActionTypeChange: (_ type: ExerciseActionType) -> Void = {type in }
    
    var body: some View {
        switch exerciseType {
        case .setsNreps:
            if isEditing {
                HStack (alignment: .center) {
                    ActionSetsNRepsEditView(actionEntity: actionEntity)
                    Spacer()
                    Button(action: {
                        isEditing.toggle()
                    }){
                        Text("Done")
                            .padding(.vertical,Constants.Design.spacing/2)
                            .padding(.leading, Constants.Design.spacing/2)
                    }
                }
            } else {
                ActionSetsNRepsView(actionEntity: actionEntity)
                    .padding(.vertical, Constants.Design.spacing/2)
            }
        case .timed:
            if isEditing {
                HStack(alignment: .center) {
                    ActionTimedEditView(actionEntity: actionEntity)
                    Spacer()
                    Button(action: {
                        isEditing.toggle()
                    }){
                        Text("Done")
                            .padding(.vertical,Constants.Design.spacing/2)
                            .padding(.leading, Constants.Design.spacing/2)
                    }
                }
            } else {
                ActionTimedView(actionEntity: actionEntity)
                    .padding(.vertical, Constants.Design.spacing/2)
            }
        case .mixed:
            if isEditing {
                HStack(alignment: .center) {
                    VStack (alignment: .leading){
                        HStack{
                            Text("Action type:")
                            Picker("Type", selection:
                                    Binding(
                                        get: { ExerciseActionType.from(rawValue: actionEntity.type ) },
                                        set: { onActionTypeChange($0) }
                                    )) {
                                ForEach(ExerciseActionType.exerciseActionTypes, id: \.self) { type in
                                    Text(type.screenTitle)
                                }
                            }
                            .labelsHidden()
                            .pickerStyle(.menu)
                        }
                        .padding(.bottom, Constants.Design.spacing/2)
                        switch ExerciseActionType.from(rawValue: actionEntity.type) {
                        case .setsNreps:
                            ActionSetsNRepsEditView(actionEntity: actionEntity, editTitle: true)
                        case .timed:
                            ActionTimedEditView(actionEntity: actionEntity, editTitle: true)
                        case .unknown:
                            Text(Constants.Design.Placeholders.noActionDetails)
                        }
                    }
                    Spacer()
                    Button(action: {
                        isEditing.toggle()
                    }){
                        Text("Done")
                            .padding(.vertical,Constants.Design.spacing/2)
                            .padding(.leading, Constants.Design.spacing/2)
                    }
                }
            } else {
                switch ExerciseActionType.from(rawValue: actionEntity.type) {
                case .setsNreps:
                    ActionSetsNRepsView(actionEntity: actionEntity, showTitle: true)
                        .padding(.vertical, Constants.Design.spacing/2)
                case .timed:
                    ActionTimedView(actionEntity: actionEntity,showTitle: true)
                        .padding(.vertical, Constants.Design.spacing/2)
                case .unknown:
                    Text(Constants.Design.Placeholders.noActionDetails)
                }
            }
        
        case .unknown:
            Text(Constants.Design.Placeholders.noActionDetails)
        }
    }
}

struct ActionEditSwitchView_Previews: PreviewProvider {
    
    static var previews: some View {

        let persistenceController = PersistenceController.preview
        let workoutCarouselViewModel = WorkoutCarouselViewModel(context: persistenceController.container.viewContext)
        let workoutEditViewModel = WorkoutEditTemporaryViewModel(parentViewModel: workoutCarouselViewModel, editingWorkout: workoutCarouselViewModel.workouts[0])
        let exerciseEditViewModel = ExerciseEditTemporaryViewModel(parentViewModel: workoutEditViewModel, editingExercise: workoutEditViewModel.exercises[2])
        
        let action = exerciseEditViewModel.exerciseActions[0]
        let exerciseType = exerciseEditViewModel.editingExercise?.type
        
        let isEditingBinding = Binding<Bool>(
            get: {
                true
            },
            set: { isEditing in
                if isEditing {
                    exerciseEditViewModel.setEditingAction(action)
                } else {
                    exerciseEditViewModel.clearEditingAction()
                }
            }
        )
        
        VStack (spacing: 50 ) {
            ActionEditSwitchView(actionEntity: action, isEditing: .constant(false), exerciseType: ExerciseType.from(rawValue: exerciseType))
            
            ActionEditSwitchView(actionEntity: action, isEditing: isEditingBinding, exerciseType: ExerciseType.from(rawValue: exerciseType))
                
        }

    }
}

