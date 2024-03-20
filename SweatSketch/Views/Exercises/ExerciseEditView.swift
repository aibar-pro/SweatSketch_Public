//
//  ExerciseView.swift
//  MyWorkoutPlanner
//
//  Created by aibaranchikov on 12/5/21.
//

import SwiftUI

struct ExerciseEditView: View {
    
    @EnvironmentObject var coordinator: ExerciseEditCoordinator
    @ObservedObject var viewModel: ExerciseEditTemporaryViewModel

    @GestureState var titlePress = false
    @State private var newExerciseName : String = ""
    @State private var isEditingName : Bool = false
    
    @State private var exerciseType: ExerciseType = .setsNreps
    
    @State private var supersetsCount: Int = 1
    
    @State var isEditingList : Bool = false
    
    var body: some View {
        GeometryReader { geoReader in
            VStack (alignment: .leading) {
                HStack {
                    Button(action: {
                        if isEditingList {
                            isEditingList = false
                        } else if isEditingName {
                            isEditingName = false
                        } else {
                            print("Exercise DISCARD")
                            coordinator.discardExerciseEdit()
                        }
                    }) {
                        Text("Cancel")
                            .padding(.vertical, Constants.Design.spacing/2)
                            .padding(.trailing, Constants.Design.spacing/2)
                    }
                    Spacer()
                    Button(action: {
                        if isEditingList {
                            isEditingList = false
                        } else if isEditingName {
                            viewModel.renameExercise(newName: newExerciseName)
                            newExerciseName.removeAll()
                            isEditingName = false
                        } else {
                            print("Exercise SAVE")
                            coordinator.saveExerciseEdit()
                        }
                    }) {
                        Text(isEditingName ? "Done" : "Save")
                            .bold()
                            .padding(.vertical, Constants.Design.spacing/2)
                            .padding(.leading, Constants.Design.spacing/2)
                    }
                    //                    .disabled(newExerciseName.isEmpty&&isEditingName)
                }
                .padding(.horizontal, Constants.Design.spacing)
                
                Text(viewModel.editingExercise?.name ?? "\"unnamed\"")
                    .font(.title2.bold())
                    .lineLimit(2)
                    .padding(.horizontal, Constants.Design.spacing)
                    .padding(.bottom, Constants.Design.spacing/2)
                    .scaleEffect(titlePress ? 0.95 : 1)
                    .animation(.spring(response: 0.4, dampingFraction: 0.6))
                    .gesture(
                        LongPressGesture(minimumDuration: 0.5)
                            .updating($titlePress) { currentState, gestureState, transaction in
                                gestureState = currentState
                            }
                            .onEnded { value in
                                isEditingName = true
                            }
                    )
                    .disabled(isEditingName || isEditingList)
                
                if isEditingName {
                    HStack {
                        Text("Name: ")
                        
                        TextField("New exercise name", text: $newExerciseName)
                            .disabled(isEditingList)
                    }
                    .padding(.horizontal, Constants.Design.spacing)
                    .padding(.bottom, Constants.Design.spacing/2)
                }
                
                if !isEditingName {
                    Picker("Type", selection: $exerciseType) {
                        ForEach(ExerciseType.exerciseTypes, id: \.self) { type in
                            Text(type.screenTitle)
                        }
                    }
                    .onAppear(perform: {
                        exerciseType = ExerciseType.from(rawValue: viewModel.editingExercise?.type)
                    })
                    .onChange(of: exerciseType, perform: { _ in
                        viewModel.setExerciseType(type: ExerciseType.from(rawValue: exerciseType.rawValue))
                    })
                    .pickerStyle(.segmented)
                    .padding(.horizontal, Constants.Design.spacing)
                    .padding(.bottom, Constants.Design.spacing/2)
                    
                    if exerciseType == .mixed {
                        HStack {
                            Text("Superset reps:")
                            
                            Picker("", selection: $supersetsCount) {
                                ForEach(1...99, id: \.self) {
                                    Text("\($0)")
                                }
                            }
                            .pickerStyle(.menu)
                            .onAppear(perform: {
                                if let superSets = viewModel.editingExercise?.superSets {
                                    supersetsCount = Int(superSets)
                                } else {
                                    supersetsCount = 1
                                }
                            })
                            .onChange(of: supersetsCount, perform: { _ in
                                viewModel.setSupersets(superset: supersetsCount)
                            })
                        }
                        .padding(.horizontal, Constants.Design.spacing)
                        .padding(.bottom, Constants.Design.spacing/2)
                    }
                    List {
                        ForEach(viewModel.exerciseActions) { action in
                                ExerciseActionEditView(exerciseAction: action, exerciseType: exerciseType)
                        }
                    }
                    .listStyle(.plain)
                    .environment(\.editMode,
                                  .constant(isEditingList ? EditMode.active : EditMode.inactive))
                    .animation(.easeInOut(duration: 0.25))
                    .onChange(of: viewModel.exerciseActions.count==0, perform: { _ in
                        if isEditingList {
                            isEditingList = false
                        }
                    })
//                    List {
//                        ForEach(viewModel.exerciseActions.filter { action in
//                            switch exerciseType {
//                            case .setsNreps:
//                                return ExerciseActionType.from(rawValue: action.type) == .setsNreps
//                            case .timed:
//                                return ExerciseActionType.from(rawValue: action.type) == .timed
//                            case .mixed:
//                                return ExerciseActionType.from(rawValue: action.type) == .setsNreps || ExerciseActionType.from(rawValue: action.type) == .timed
//                            case .unknown:
//                                return ExerciseActionType.from(rawValue: action.type) == .unknown
//                            }
//                        }) { action in
//                            let actionType = ExerciseActionType.from(rawValue: action.type)
//                            
//                            HStack {
//                                if exerciseType == .mixed {
//                                    if let actionName = action.name {
//                                        Text(actionName+",")
//                                    } else {
//                                        Text("\"unnamed\"")
//                                    }
//                                    
//                                    switch actionType {
//                                    case .setsNreps:
//                                        if action.repsMax {
//                                            Text("xMAX")
//                                        } else {
//                                            Text("x\(action.reps)")
//                                        }
//                                    case .timed:
//                                        Text("\(action.duration) seconds")
//                                    case .unknown:
//                                        EmptyView()
//                                    }
//                                } else {
//                                    switch actionType {
//                                    case .setsNreps:
//                                        Text("\(action.sets)x\(action.repsMax ? "MAX" : String(action.reps))")
//                                    case .timed:
//                                        Text("\(action.duration) seconds")
//                                    case .unknown:
//                                        EmptyView()
//                                    }
//                                }
//                            }
//                            .listRowBackground(Color.clear)
//                            
//                        }
//                        .onDelete(perform: coordinator.viewModel.deleteExerciseActions)
//                        .onMove(perform: coordinator.viewModel.reorderWorkoutExerciseActions)
//                            // Why?
//                        .disabled(isEditingList)
//                    }
//                    .listStyle(.plain)
//                    .environment(\.editMode,
//                                  .constant(isEditingList ? EditMode.active : EditMode.inactive))
//                    .animation(.easeInOut(duration: 0.25))
//                    .onChange(of: viewModel.exerciseActions.count==0, perform: { _ in
//                        if isEditingList {
//                            isEditingList = false
//                        }
//                    })
                }
                
                if !isEditingList && !isEditingName {
                    HStack {
                        Button(action: {
                            isEditingList.toggle()
                        }) {
                            Image(systemName: "arrow.up.arrow.down")
                                .padding(Constants.Design.spacing/2)
                        }
                        .disabled(viewModel.exerciseActions.isEmpty || isEditingName)
                        
                        Spacer()
                        Button(action: {
                            print("New action")
                            //                        let addedExerciseItem = ExerciseActionEntity(context: viewContext)
                            //                                    self.newExerciseItems.append(addedExerciseItem)
                        }) {
                            Image(systemName: "plus")
                                .font(.title2.bold())
                                .primaryButtonLabelStyleModifier()
                        }
                    }
                    .padding(.horizontal, Constants.Design.spacing)
                } else {
                    EmptyView()
                }
            }
            .accentColor(.primary)
        }
    }
}

import CoreData

struct ExerciseEditView_Previews: PreviewProvider {
    static var previews: some View {
        
        let persistenceController = PersistenceController.preview
        let workoutCarouselViewModel = WorkoutCarouselViewModel(context: persistenceController.container.viewContext)
        let workoutEditViewModel = WorkoutEditTemporaryViewModel(parentViewModel: workoutCarouselViewModel, editingWorkout: workoutCarouselViewModel.workouts[0])
        let exerciseEditViewModel = ExerciseEditTemporaryViewModel(parentViewModel: workoutEditViewModel, editingExercise: workoutEditViewModel.exercises[0])
        let exerciseCoordinator = ExerciseEditCoordinator(viewModel: exerciseEditViewModel)
        
        ExerciseEditView(viewModel: exerciseEditViewModel)
            .environmentObject(exerciseCoordinator)
    }
}
