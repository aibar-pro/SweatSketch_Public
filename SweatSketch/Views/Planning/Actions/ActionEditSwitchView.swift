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
                ActionSetsNRepsEditView(actionEntity: actionEntity)
            } else {
                ActionSetsNRepsView(actionEntity: actionEntity)
            }
        case .timed:
            if isEditing {
                ActionTimedEditView(actionEntity: actionEntity)
            } else {
                ActionTimedView(actionEntity: actionEntity)
            }
        case .mixed:
            if isEditing {
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
            } else {
                switch ExerciseActionType.from(rawValue: actionEntity.type) {
                case .setsNreps:
                    ActionSetsNRepsView(actionEntity: actionEntity, showTitle: true)
                case .timed:
                    ActionTimedView(actionEntity: actionEntity,showTitle: true)
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
        let exerciseEditViewModel = ExerciseEditTemporaryViewModel(parentViewModel: workoutEditViewModel, editingExercise: workoutEditViewModel.exercises[0])
        
        let action = exerciseEditViewModel.exerciseActions[0]
        let exerciseType = exerciseEditViewModel.editingExercise?.type
        
//        let isEditingBinding = Binding<Bool>(
//            get: {
//                true
//            },
//            set: { isEditing in
//                if isEditing {
//                    exerciseEditViewModel.setEditingAction(action)
//                } else {
//                    exerciseEditViewModel.clearEditingAction()
//                }
//            }
//        )
        
        VStack (spacing: 50 ) {
            ActionEditSwitchView(actionEntity: action, isEditing: .constant(false), exerciseType: ExerciseType.from(rawValue: exerciseType))
            
            ActionEditSwitchView(actionEntity: action, isEditing: .constant(true), exerciseType: ExerciseType.from(rawValue: exerciseType))
                
        }

    }
}

