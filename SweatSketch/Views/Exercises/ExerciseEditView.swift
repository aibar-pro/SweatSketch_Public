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
    
    @State var isEditingList : Bool = false
    
    var body: some View {
        ZStack {
            BackgroundGradientView()
            
            GeometryReader { geoReader in
                VStack (alignment: .leading) {
                    HStack {
                        Button(action: {
                            if isEditingList {
                                isEditingList = false
                            } else if isEditingName {
                                isEditingName = false
                            } else if viewModel.isEditingAction {
                                viewModel.clearEditingAction()
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
                            } else if viewModel.isEditingAction {
                                viewModel.clearEditingAction()
                            } else {
                                print("Exercise SAVE")
                                coordinator.saveExerciseEdit()
                            }
                        }) {
                            if isEditingName {
                                Text("Rename")
                                    .bold()
                                    .padding(.vertical, Constants.Design.spacing/2)
                                    .padding(.leading, Constants.Design.spacing/2)
                            } else if viewModel.isEditingAction || isEditingList {
                                Text("Done")
                                    .bold()
                                    .padding(.vertical, Constants.Design.spacing/2)
                                    .padding(.leading, Constants.Design.spacing/2)
                            } else {
                                Text("Save")
                                    .bold()
                                    .padding(.vertical, Constants.Design.spacing/2)
                                    .padding(.leading, Constants.Design.spacing/2)
                            }
                        }
                        .disabled(isEditingName && newExerciseName.isEmpty)
                    }
                    .padding(.top, Constants.Design.spacing/2)
                    .padding(.horizontal, Constants.Design.spacing)
                    
                    Text(viewModel.editingExercise?.name ?? Constants.Design.Placeholders.noExerciseName)
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
                        .disabled(isEditingName || isEditingList || viewModel.isEditingAction)
                    
                    if !isEditingName {
                        Picker("Type", selection:
                                Binding(get: { ExerciseType.from(rawValue: self.viewModel.editingExercise?.type) }, set: { self.viewModel.setEditingExerciseType(to: $0) }
                                       )) {
                            ForEach(ExerciseType.exerciseTypes, id: \.self) { type in
                                Text(type.screenTitle)
                                
                            }
                        }
                       .disabled(isEditingName || isEditingList || viewModel.isEditingAction)
                       .pickerStyle(.segmented)
                       .padding(.horizontal, Constants.Design.spacing)
                       .padding(.bottom, Constants.Design.spacing/2)
                        
                        if ExerciseType.from(rawValue: viewModel.editingExercise?.type) == .mixed {
                            HStack {
                                Text("Superset repetitions:")
                                
                                Picker("Superset reps", selection: Binding(
                                    get: { Int(viewModel.editingExercise?.superSets ?? 1)},
                                    set: { viewModel.setSupersets(superset: $0)}))
                                {
                                    ForEach(1...99, id: \.self) {
                                        Text("\($0)")
                                    }
                                }
                                .labelsHidden()
                                .disabled(isEditingName || isEditingList || viewModel.isEditingAction)
                                .pickerStyle(.menu)
                            }
                            .padding(.horizontal, Constants.Design.spacing)
                            .padding(.bottom, Constants.Design.spacing/2)
                        }
                        GeometryReader { listGeo in
                            //TODO: Consider View change: from List to ScrollView
                            List {
                                ForEach(viewModel.exerciseActions.filter { action in
                                    switch ExerciseType.from(rawValue: viewModel.editingExercise?.type) {
                                    case .setsNreps:
                                        return ExerciseActionType.from(rawValue: action.type) == .setsNreps
                                    case .timed:
                                        return ExerciseActionType.from(rawValue: action.type) == .timed
                                    case .mixed:
                                        return ExerciseActionType.from(rawValue: action.type) == .setsNreps || ExerciseActionType.from(rawValue: action.type) == .timed
                                    case .unknown:
                                        return ExerciseActionType.from(rawValue: action.type) == .unknown
                                    }
                                })
                                { action in
                                    let isEditingBinding = Binding<Bool>(
                                        get: {
                                            viewModel.isEditingAction(action)
                                        },
                                        set: { isEditing in
                                            if isEditing {
                                                viewModel.setEditingAction(action)
                                            } else {
                                                viewModel.clearEditingAction()
                                            }
                                        }
                                    )
                                    
                                    HStack (alignment: .center) {
                                        let exerciseType = ExerciseType.from(rawValue: viewModel.editingExercise?.type)
                                        
                                        ActionEditSwitchView(actionEntity: action, isEditing: isEditingBinding, exerciseType: exerciseType) {
                                            type in
                                            viewModel.setEditingActionType(to: type)
                                        }
                                            .animation(.linear(duration: 0.25))
                                            .frame(height:  listGeo.size.height/getRowHeightMultiplier(exerciseType: exerciseType, actionType: ExerciseActionType.from(rawValue: action.type), actionIsEditing: isEditingBinding.wrappedValue))
                                        Spacer()
                                        if viewModel.editingAction == nil {
                                            Button(action: {
                                                if viewModel.editingAction == action {
                                                    viewModel.editingAction = nil
                                                } else {
                                                    viewModel.setEditingAction(action)
                                                }
                                            }) {
                                                Image(systemName: "ellipsis")
                                            }
                                            .disabled(isEditingName || isEditingList || viewModel.isEditingAction)
                                        }
                                    }
                                    .padding(.horizontal, Constants.Design.spacing/2)
                                    .padding(.vertical, Constants.Design.spacing)
                                    .listRowBackground(
                                        RoundedRectangle(cornerRadius: Constants.Design.cornerRadius, style: .continuous)
                                            .fill(
                                                Color.clear
                                            )
                                            .modifier(CardBackgroundModifier(cornerRadius: Constants.Design.cornerRadius))
                                            .padding(.all, Constants.Design.spacing/2)
                                    )
                                }
                                .onMove(perform: viewModel.moveExerciseActions)
                                .onDelete(perform: viewModel.deleteExerciseActions)
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
                            
                            //                        }
                            //                        .onDelete(perform: coordinator.viewModel.deleteExerciseActions)
                            //                        .onMove(perform: coordinator.viewModel.reorderWorkoutExerciseActions)
                            //                            // Why?
                            //                        .disabled(isEditingList)
                            //                    }
                          
                        }
                    } else {
                        VStack {
                            HStack {
                                Text("Name: ")
                                
                                TextField("New exercise name", text: $newExerciseName)
                            }
                            .padding(.horizontal, Constants.Design.spacing)
                            .padding(.bottom, Constants.Design.spacing/2)
                        }
                        
                    }
                    
                    if !isEditingName {
                        HStack {
                            Button(action: {
                                isEditingList.toggle()
                            }) {
                                Image(systemName: "arrow.up.arrow.down")
                                    .padding(Constants.Design.spacing/2)
                            }
                            .disabled(viewModel.exerciseActions.isEmpty || isEditingName || viewModel.isEditingAction)
                            
                            Spacer()
                            Button(action: {
                                print("New action")
                                viewModel.addExerciseAction()
                            }) {
                                Image(systemName: "plus")
                                    .font(.title2.bold())
                                    .primaryButtonLabelStyleModifier()
                            }
                            .disabled(isEditingName || isEditingList || viewModel.isEditingAction)
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
    
    private func getRowHeightMultiplier(exerciseType: ExerciseType, actionType: ExerciseActionType, actionIsEditing: Bool) -> CGFloat {
        if !actionIsEditing { return 10 }
        else {
            switch actionType {
            case .timed:
                if exerciseType == .mixed {
                    return 2.5
                } else {
                    return 6
                }
            default:
                if exerciseType == .mixed {
                    return 3.5
                } else {
                    return 10
                }
            }
        }
    }
}

struct ExerciseEditView_Previews: PreviewProvider {
    static var previews: some View {
        
        let persistenceController = PersistenceController.preview
        let workoutCarouselViewModel = WorkoutCarouselViewModel(context: persistenceController.container.viewContext)
        let workoutEditViewModel = WorkoutEditTemporaryViewModel(parentViewModel: workoutCarouselViewModel, editingWorkout: workoutCarouselViewModel.workouts[0])
        let exerciseEditViewModel = ExerciseEditTemporaryViewModel(parentViewModel: workoutEditViewModel, editingExercise: workoutEditViewModel.exercises[2])
        let exerciseCoordinator = ExerciseEditCoordinator(viewModel: exerciseEditViewModel)
        
        ExerciseEditView(viewModel: exerciseEditViewModel)
            .environmentObject(exerciseCoordinator)
    }
}
