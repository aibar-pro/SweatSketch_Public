//
//  ExerciseItemView.swift
//  MyWorkoutPlanner
//
//  Created by aibaranchikov on 7/5/21.
//

import SwiftUI

struct ExerciseActionEditView: View {
    @ObservedObject var exerciseAction: ExerciseActionEntity
    
    @Binding var isEditing: Bool
    
    var exerciseType: ExerciseType
    
    var onActionTypeChange: (_ type: ExerciseActionType) -> Void = {type in }
    
    var body: some View {
        switch exerciseType {
        case .setsNreps:
            if isEditing {
                HStack (alignment: .center) {
                    ActionSetsNRepsEditView(exerciseAction: exerciseAction)
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
                ActionSetsNRepsView(exerciseAction: exerciseAction)
                    .padding(.vertical, Constants.Design.spacing/2)
            }
        case .timed:
            if isEditing {
                HStack(alignment: .center) {
                    ActionTimedEditView(exerciseAction: exerciseAction)
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
                ActionTimedView(exerciseAction: exerciseAction)
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
                                        get: { ExerciseActionType.from(rawValue: exerciseAction.type ) },
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
                        switch ExerciseActionType.from(rawValue: exerciseAction.type) {
                        case .setsNreps:
                            ActionSetsNRepsEditView(exerciseAction: exerciseAction, editTitle: true)
                        case .timed:
                            ActionTimedEditView(exerciseAction: exerciseAction, editTitle: true)
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
                switch ExerciseActionType.from(rawValue: exerciseAction.type) {
                case .setsNreps:
                    ActionSetsNRepsView(exerciseAction: exerciseAction, showTitle: true)
                        .padding(.vertical, Constants.Design.spacing/2)
                case .timed:
                    ActionTimedView(exerciseAction: exerciseAction,showTitle: true)
                        .padding(.vertical, Constants.Design.spacing/2)
                case .unknown:
                    Text(Constants.Design.Placeholders.noActionDetails)
                }
            }
        
        case .unknown:
            EmptyView()
        }
        
//        GeometryReader { gReader in
//            VStack (alignment: .leading, spacing: 5) {
//                
//                if true {
//                    HStack {
//                        Picker("", selection: $timeHour) {
//                            ForEach(0...23, id: \.self) {
//                                  Text("\($0)")
//                            }
//                        }
//                        .pickerStyle(WheelPickerStyle())
//                        .frame(width: gReader.size.width * 0.2)
//                        Text(":")
//                        Picker("", selection: $timeMinute) {
//                            ForEach(0...59, id: \.self) {
//                                  Text("\($0)")
//                            }
//                        }
//                        .pickerStyle(WheelPickerStyle())
//                        .frame(width: gReader.size.width * 0.2)
//                        Text(":")
//                        Picker("", selection: $timeSecond) {
//                            ForEach(0...59, id: \.self) {
//                                  Text("\($0)")
//                            }
//                        }
//                        .pickerStyle(WheelPickerStyle())
//                        .frame(width: gReader.size.width * 0.2)
//                    }
//                    .padding(.leading, 20)
//                    .frame(width: gReader.size.width-20, height: 50, alignment: .center)
//                } else {
//                    EmptyView()
//                }
//                
//                if true {
//                    HStack (spacing: 20) {
//                            Text("Sets")
//
//                            Picker(selection: self.$setsCount, label:
//                                Text("\(self.setsCount)")
//                            ){
//                                ForEach(1...99, id: \.self) {
//                                      Text("\($0)")
//                                  }
//                            }
//                            .pickerStyle(WheelPickerStyle())
//                            .frame(width: gReader.size.width * 0.2)
//                            .onChange(of: self.setsCount, perform: { value in
//                                exerciseAction.sets = Int16(value)
//                            })
//
//                        Divider()
//                            .fixedSize()
//                        
//                        Text("Reps")
//                            .font(.title3)
//                        
//                        Picker(selection: self.$repsCount, label:
//                            Text("\(self.repsCount)")
//                        ){
//                            ForEach(1...99, id: \.self) {
//                                  Text("\($0)")
//                            }
//                        }
//                        .pickerStyle(WheelPickerStyle())
//                        .frame(width: gReader.size.width * 0.2)
//                        .onChange(of: self.repsCount, perform: { value in
//                            exerciseAction.reps = Int16(value)
//                        })
//                    }
//                    .frame(width: gReader.size.width, height: 50, alignment: .center)
//                } else {
//                    /*@START_MENU_TOKEN@*/EmptyView()/*@END_MENU_TOKEN@*/
//                }
//            }
//            .frame(width: gReader.size.width)
//        }
//        .frame(height: self.showWeightPlates ? CGFloat(300) : CGFloat(105), alignment: .center)
    }
}


struct ExerciseActionEditView_Previews: PreviewProvider {
    
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
            ExerciseActionEditView(exerciseAction: action, isEditing: .constant(false), exerciseType: ExerciseType.from(rawValue: exerciseType))
            
            ExerciseActionEditView(exerciseAction: action, isEditing: isEditingBinding, exerciseType: ExerciseType.from(rawValue: exerciseType))
                
        }

    }
}

