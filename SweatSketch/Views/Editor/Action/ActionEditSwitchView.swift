//
//  ActionEditSwitchView.swift
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
                if let actionRepresentation = actionEntity.toExerciseActionViewRepresentation() {
                    ActionSetsNRepsView(action: actionRepresentation)
                }
            }
        case .timed:
            if isEditing {
                ActionTimedEditView(actionEntity: actionEntity)
            } else {
                if let actionRepresentation = actionEntity.toExerciseActionViewRepresentation() {
                    ActionTimedView(action: actionRepresentation)
                }
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
                        ActionSetsNRepsEditView(actionEntity: actionEntity, editTitle: true, editSets: false)
                    case .timed:
                        ActionTimedEditView(actionEntity: actionEntity, editTitle: true)
                    case .unknown:
                        Text(Constants.Placeholders.noActionDetails)
                    }
                }
            } else {
                switch ExerciseActionType.from(rawValue: actionEntity.type) {
                case .setsNreps:
                    if let actionRepresentation = actionEntity.toExerciseActionViewRepresentation() {
                        ActionSetsNRepsView(action: actionRepresentation, showTitle: true, showSets: false)
                    }
                case .timed:
                    if let actionRepresentation = actionEntity.toExerciseActionViewRepresentation() {
                        ActionTimedView(action: actionRepresentation, showTitle: true)
                    }
                case .unknown:
                    Text(Constants.Placeholders.noActionDetails)
                }
            }
        
        case .unknown:
            Text(Constants.Placeholders.noActionDetails)
        }
    }
}

struct ActionEditSwitchView_Previews: PreviewProvider {
    
    static var previews: some View {

        let persistenceController = PersistenceController.preview
        
        let collectionDataManager = CollectionDataManager()
        let firstCollection = collectionDataManager.fetchFirstUserCollection(in: persistenceController.container.viewContext)!
        let workoutForPreview = collectionDataManager.fetchWorkouts(for: firstCollection, in: persistenceController.container.viewContext).first!
        
        let workoutDataManager = WorkoutDataManager()
        
        let exerciseForPreview = workoutDataManager.fetchExercises(for: workoutForPreview, in: persistenceController.container.viewContext)[2]
        
        let exerciseDataManager = ExerciseDataManager()
        
        let actionForPreview = exerciseDataManager.fetchActions(for: exerciseForPreview, in: persistenceController.container.viewContext)[1]
        
        
        VStack (spacing: 50 ) {
            ActionEditSwitchView(actionEntity: actionForPreview, isEditing: .constant(false), exerciseType: ExerciseType.from(rawValue: exerciseForPreview.type))
            
            ActionEditSwitchView(actionEntity: actionForPreview, isEditing: .constant(true), exerciseType: ExerciseType.from(rawValue: exerciseForPreview.type))
                
        }

    }
}

