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
    
    var body: some View {
        switch exerciseType {
        case .setsNreps:
            switch isEditing {
            case true:
                HStack (alignment: .center) {
                    Picker("Sets", selection: Binding(
                       get: { Int(self.exerciseAction.sets) },
                       set: { self.exerciseAction.sets = Int16($0) }
                   )) {
                       ForEach(1...99, id: \.self) {
                           Text("\($0)").tag($0)
                       }
                   }
                   .onAppear(perform: {
                       if self.exerciseAction.sets < 1 {
                           self.exerciseAction.sets = Int16(1)
                       }
                   })
                   .labelsHidden()
                   .pickerStyle(MenuPickerStyle())
                    Text("x")
                    Picker("Reps", selection: Binding(
                       get: { Int(self.exerciseAction.reps) },
                       set: { self.exerciseAction.reps = Int16($0) }
                   )) {
                       ForEach(1...99, id: \.self) {
                           Text("\($0)").tag($0)
                       }
                   }
                   .onAppear(perform: {
                       if self.exerciseAction.reps < 1 {
                           self.exerciseAction.reps = Int16(1)
                       }
                   })
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
                    Spacer()
                    Button(action: {
                        isEditing.toggle()
                    }){
                        Text("Done")
                            .padding(.vertical,Constants.Design.spacing/2)
                            .padding(.leading, Constants.Design.spacing/2)
                    }
                }
                
            case false:
                if exerciseAction.sets > 0, (exerciseAction.repsMax || exerciseAction.reps > 0) {
                    Text("\(exerciseAction.sets)x\(exerciseAction.repsMax ? "MAX" : String(exerciseAction.reps))")
                        .padding(.vertical, Constants.Design.spacing/2)
                }
            }
            
        case .timed:
            if exerciseAction.duration > 0 {
                Text("\(exerciseAction.duration) seconds")
            }
        case .mixed:
            HStack{
                if let actionName = exerciseAction.name {
                    Text(actionName+",")
                } else {
                    Text(Constants.Design.Placeholders.exerciseActionName+",")
                }
                
//                TextField("Action Name", text: Binding(
//                                    get: { self.exerciseAction.name ?? "" },
//                                    set: { self.exerciseAction.name = $0 }
//                                ))
//                                .textFieldStyle(RoundedBorderTextFieldStyle())
//                                .padding(.bottom)
                let actionType = ExerciseActionType.from(rawValue: exerciseAction.type)
                
                switch actionType {
                case .setsNreps:
                    if exerciseAction.repsMax {
                        Text("xMAX")
                    } else {
                        Text("x\(exerciseAction.reps)")
                    }
                case .timed:
                    Text("\(exerciseAction.duration) seconds")
                case .unknown:
                    Text("unknown action type")
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

import CoreData

struct ExerciseActionEditView_Previews: PreviewProvider {
    
    
    static var previews: some View {
      
        let persistenceController = PersistenceController.preview
        let workoutCarouselViewModel = WorkoutCarouselViewModel(context: persistenceController.container.viewContext)
        let workoutEditViewModel = WorkoutEditTemporaryViewModel(parentViewModel: workoutCarouselViewModel, editingWorkout: workoutCarouselViewModel.workouts[0])
        let exerciseEditViewModel = ExerciseEditTemporaryViewModel(parentViewModel: workoutEditViewModel, editingExercise: workoutEditViewModel.exercises[1])
        
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

