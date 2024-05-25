//
//  WorkoutEditView.swift
//  MyWorkoutPlanner
//
//  Created by aibaranchikov on 24.11.2023.
//

import SwiftUI

struct WorkoutEditView: View {
    
    @EnvironmentObject var coordinator: WorkoutEditCoordinator
    @ObservedObject var viewModel: WorkoutEditViewModel
    
    @GestureState var titlePress = false
    
    enum EditingState {
        case none
        case name
        case list
        case restTime
    }
    @State private var currentEditingState: EditingState = .none
    
    var body: some View {
        ZStack {
            GeometryReader { gReader in
                VStack (alignment: .leading, spacing: Constants.Design.spacing/2) {
                    HStack {
                        Button(action: {
                            switch self.currentEditingState {
                            case .none:
                                coordinator.discardWorkoutEdit()
                            default:
                                currentEditingState = .none
                            }
                        }) {
                            Text(Constants.Placeholders.cancelButtonLabel)
                                .padding(.vertical, Constants.Design.spacing/2)
                                .padding(.trailing, Constants.Design.spacing/2)
                        }
                        .disabled(currentEditingState == .list)
                        
                        Spacer()
                        
                        Button(action: {
                           viewModel.undo()
                        }) {
                            Image(systemName: "arrow.uturn.backward")
                        }
                        .padding(.vertical, Constants.Design.spacing/2)
                        .padding(.horizontal, Constants.Design.spacing/2)
                        .disabled(!viewModel.canUndo || currentEditingState != .none)
                        
                        Button(action: {
                            viewModel.redo()
                        }) {
                            Image(systemName: "arrow.uturn.forward")
                        }
                        .padding(.vertical, Constants.Design.spacing/2)
                        .padding(.horizontal, Constants.Design.spacing/2)
                        .disabled(!viewModel.canRedo || currentEditingState != .none)
                        
                        Spacer()
                        
                        Button(action: {
                            if currentEditingState == .none {
                                coordinator.saveWorkoutEdit()
                            } else {
                                currentEditingState = .none
                            }
                        }) {
                            Text(
                                currentEditingState == .list ?
                                Constants.Placeholders.doneButtonLabel :
                                    Constants.Placeholders.saveButtonLabel
                            )
                            .bold()
                            .padding(.vertical, Constants.Design.spacing/2)
                            .padding(.leading, Constants.Design.spacing/2)
                        }
                        .disabled(isSaveButtonDisable())
                    }
                    .padding(.horizontal, Constants.Design.spacing)
                    
                    Text(viewModel.editingWorkout.name ?? Constants.Placeholders.noWorkoutName)
                        .font(.title2.bold())
                        .lineLimit(2)
                        .padding(.horizontal, Constants.Design.spacing)
                        .scaleEffect(titlePress ? 0.95 : 1)
                        .animation(.spring(response: 0.4, dampingFraction: 0.6))
                        .gesture(
                              LongPressGesture(minimumDuration: 0.35)
                                  .updating($titlePress) { currentState, gestureState, transaction in
                                      gestureState = currentState
                                  }
                                  .onEnded { value in
                                      if currentEditingState == .none {
                                          currentEditingState = .name
                                      } else {
                                          currentEditingState = .none
                                      }
                                        
                                  }
                          )
                        .disabled(isRenameDisabled())
                    
                    ZStack {
                        List {
                            ForEach (viewModel.exercises, id: \.self) { exercise in
                                HStack (alignment: .top){
                                    if let exerciseRepresentation = exercise.toExerciseViewRepresentation(){
                                        ExerciseView(exerciseRepresentation: exerciseRepresentation)
                                    }
                                    Spacer()
                                    Button(action: {
                                        print("Edit exercise: \(exercise.name ?? "")")
                                        coordinator.goToEditWorkout(exerciseToEdit: exercise)
                                    }) {
                                        Image(systemName: "ellipsis")
                                            .font(.title3)
                                            .padding(.trailing, Constants.Design.spacing/4)
                                            .padding(.vertical, Constants.Design.spacing/4)
                                    }
                                }
                                .padding(.vertical, Constants.Design.spacing/4)
                                .listRowBackground(
                                    RoundedRectangle(cornerRadius: Constants.Design.cornerRadius, style: .continuous)
                                        .fill(
                                            Color.clear
                                        )
                                        .materialCardBackgroundModifier()
                                        .padding(.all, Constants.Design.spacing/4)
                                )
                            }
                            .onDelete { index in viewModel.deleteWorkoutExercise(at: index) }
                            .onMove(perform: viewModel.reorderWorkoutExercise)
                        }
                        .padding(.horizontal, Constants.Design.spacing/2)
                        .opacity(isListEditDisabled() ? 0.2 : 1)
                        .disabled(isListEditDisabled())
                        .listStyle(.plain)
                        .environment(\.editMode,
                                      .constant(currentEditingState == .list ? EditMode.active : EditMode.inactive))
                        .animation(.easeInOut(duration: 0.25))
                        .onChange(of: viewModel.exercises.count==0, perform: { _ in
                            if currentEditingState == .list {
                                currentEditingState = .none
                            }
                        })
                        
                        VStack {
                            if currentEditingState == .name {
                                TextFieldPopoverView(
                                    popoverTitle: Constants.Placeholders.WorkoutCollection.renameWorkoutPopupTitle,
                                    textFieldLabel: Constants.Placeholders.renamePopupText,
                                    buttonLabel: Constants.Placeholders.renamePopupButtonLabel,
                                    onDone: { newName in
                                        viewModel.renameWorkout(newName: newName)
                                        currentEditingState = .none
                                    }, onDiscard: {
                                        currentEditingState = .none
                                    })
                            }
                            
                            Spacer()
                            
                            if currentEditingState == .restTime {
                                WorkoutDefaultRestTimeView(onSave: { newDuration in
                                    viewModel.updateDefaultRestTime(duration: newDuration)
                                    currentEditingState = .none
                                }, onDiscard: {
                                    currentEditingState = .none
                                }, onAdvancedEdit: {
                                    coordinator.goToAdvancedEditRestPeriod()
                                    currentEditingState = .none
                                }, duration: Int(viewModel.defaultRestTime.duration))
                                    .padding(Constants.Design.spacing)
                                    .materialCardBackgroundModifier()
                            }
                        }
                    }
                    HStack (alignment: .bottom, spacing: Constants.Design.spacing) {
                        Button(action: {
                            if currentEditingState == .none {
                                currentEditingState = .list
                            } else {
                                currentEditingState = .none
                            }
                        }) {
                            Image(systemName: "arrow.up.arrow.down")
                                .padding(Constants.Design.spacing/2)
                        }
                        .disabled(isListEditDisabled())
                      
                        Button(action: {
                            switch currentEditingState {
                            case .none:
                                currentEditingState = .restTime
                            case .restTime:
                                currentEditingState = .none
                            default:
                                break
                            }
                        }) {
                            HStack (alignment: .center, spacing: Constants.Design.spacing/4) {
                                Image(systemName: "timer")
                                   
                                if currentEditingState != .restTime {
                                    DurationView(durationInSeconds: Int(viewModel.defaultRestTime.duration))
                                } else {
                                    Text(Constants.Placeholders.noDuration)
                                }
                            }
                            .padding(Constants.Design.spacing/2)
                        }
                        .disabled(isRestTimeEditDisabled())
                    
                        Spacer()
                        Button(action: {
                            coordinator.goToAddExercise()
                        }) {
                            Image(systemName: "plus")
                                .font(.title2.bold())
                                .primaryButtonLabelStyleModifier()
                        }
                        .disabled(currentEditingState != .none)
                    }
                    .padding(.horizontal, Constants.Design.spacing)
                }
                .accentColor(Constants.Design.Colors.textColorHighEmphasis)
            }
        }
    }
    
    func isSaveButtonDisable() -> Bool {
        return currentEditingState == .name || currentEditingState == .restTime
    }
    
    func isRenameDisabled() -> Bool {
        return currentEditingState == .list || currentEditingState == .restTime
    }
    
    func isRestTimeEditDisabled() -> Bool {
        return currentEditingState == .name || currentEditingState == .list
    }
    
    func isListEditDisabled() -> Bool {
        return viewModel.exercises.isEmpty || currentEditingState == .name || currentEditingState == .restTime
    }
}

struct WorkoutEditView_Previews: PreviewProvider {
    static var previews: some View {
        
        let persistenceController = PersistenceController.preview
        
        let collectionDataManager = CollectionDataManager()
        let firstCollection = collectionDataManager.fetchFirstUserCollection(in: persistenceController.container.viewContext)
        
        let workoutViewModel = WorkoutCollectionViewModel(context: persistenceController.container.viewContext, collectionUUID: firstCollection?.uuid)
        
        let workoutForPreview = collectionDataManager.fetchWorkouts(for: firstCollection!, in: workoutViewModel.mainContext).first
        
        let workoutEditModel = WorkoutEditViewModel(parentViewModel: workoutViewModel, editingWorkoutUUID: workoutForPreview?.uuid)
        
        let workoutEditCoordinator = WorkoutEditCoordinator(viewModel: workoutEditModel)
        
        WorkoutEditView(viewModel: workoutEditModel)
            .environmentObject(workoutEditCoordinator)

    }
}
