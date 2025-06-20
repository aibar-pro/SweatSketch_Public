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
    
    @State private var currentEditingState: EditingState = .none
    
    var body: some View {
        VStack (alignment: .leading, spacing: Constants.Design.spacing) {
            headerView
            
            workoutNameView
            
            ZStack {
                exercisesView
                
                VStack {
                    if currentEditingState == .name {
                        workoutNameEditView
                    }
                    
                    Spacer()
                    
                    if currentEditingState == .restTime {
                        restTimeEditView
                    }
                }
            }
            
            footerView
        }
        .padding(.vertical, Constants.Design.spacing / 2)
        .padding(.horizontal, Constants.Design.spacing)
    }
    
    private var headerView: some View {
        HStack(alignment: .center, spacing: Constants.Design.spacing) {
            CapsuleButton(
                "app.button.cancel.label",
                style: .inline,
                isDisabled: Binding { currentEditingState == .list } set: { _ in },
                action: {
                    if currentEditingState == .none {
                        coordinator.discardWorkoutEdit()
                    } else {
                        currentEditingState = .none
                    }
                }
            )
            
            Spacer(minLength: 0)
            
            CapsuleButton(
                "app.button.save.label",
                style: .primary,
                isDisabled: Binding { isSaveButtonDisabled } set: { _ in },
                action: {
                    if currentEditingState == .none {
                        coordinator.saveWorkoutEdit()
                    } else {
                        currentEditingState = .none
                    }
                }
            )
        }
        .overlay(
            HStack(alignment: .center, spacing: Constants.Design.spacing) {
                IconButton(
                    systemImage: "arrow.uturn.backward",
                    style: .inline,
                    isDisabled: Binding { !viewModel.canUndo || currentEditingState != .none } set: { _ in },
                    action: {
                        viewModel.undo()
                    }
                )
                
                IconButton(
                    systemImage: "arrow.uturn.forward",
                    style: .inline,
                    isDisabled: Binding { !viewModel.canRedo || currentEditingState != .none } set : { _ in },
                    action: {
                        viewModel.redo()
                    }
                )
            }
        )
    }
    
    private var workoutNameView: some View {
        Text(viewModel.editingWorkout.name ?? Constants.Placeholders.noWorkoutName)
            .fullWidthText(.title2, isBold: true)
            .lineLimit(3)
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
            .disabled(isRenameDisabled)
    }
    
    private var exercisesView: some View {
        List {
            ForEach(viewModel.exercises.compactMap { $0.toExerciseViewRepresentation() }, id: \.id) { exercise in
                HStack (alignment: .firstTextBaseline, spacing: Constants.Design.spacing) {
                    ExerciseDetailView(exercise: exercise)
                    
                    Spacer(minLength: 0)
                    
                    if currentEditingState == .none {
                        IconButton(
                            systemImage: "ellipsis",
                            style: .inline,
                            action: {
                                print("\(type(of: self)): Edit exercise: \(exercise.name)")
                                guard let exerciseEntityToEdit = viewModel.exercises.first(where: { $0.uuid == exercise.id }) else {
                                    print("\(type(of: self)): Could not find exercise to edit")
                                    return
                                }
                                coordinator.goToEditExercise(exerciseToEdit: exerciseEntityToEdit)
                            }
                        )
                    }
                }
                .padding(.vertical, Constants.Design.spacing / 2)
                .listRowBackground(Color.clear)
            }
            .onDelete { index in viewModel.deleteWorkoutExercise(at: index) }
            .onMove(perform: viewModel.reorderWorkoutExercise)
        }
        .opacity(isListEditDisabled ? 0.2 : 1)
        .disabled(isListEditDisabled)
        .listStyle(.plain)
        .listRowInsets(EdgeInsets())
        .materialCardBackgroundModifier()
        .environment(\.editMode,
                      .constant(currentEditingState == .list ? EditMode.active : EditMode.inactive))
        .animation(.easeInOut(duration: 0.25))
        .onChange(of: viewModel.exercises.count == 0) { _ in
            if currentEditingState == .list {
                currentEditingState = .none
            }
        }
    }
    
    private var workoutNameEditView: some View {
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
    
    private var restTimeEditView: some View {
        WorkoutDefaultRestTimeView(
            onSave: { newDuration in
                viewModel.updateDefaultRestTime(duration: newDuration)
                currentEditingState = .none
            },
            onDiscard: {
                currentEditingState = .none
            },
            onAdvancedEdit: {
                coordinator.goToAdvancedEditRestPeriod()
                currentEditingState = .none
            },
            duration: viewModel.defaultRestTime.duration.int
        )
        .padding(Constants.Design.spacing)
        .materialCardBackgroundModifier()
    }
    
    private var footerView: some View {
        HStack (alignment: .bottom, spacing: Constants.Design.spacing) {
            IconButton(
                systemImage: "arrow.up.arrow.down",
                style: .secondary,
                isDisabled: Binding { isListEditDisabled } set: { _ in },
                action: {
                    if currentEditingState == .none {
                        currentEditingState = .list
                    } else {
                        currentEditingState = .none
                    }
                }
            )
          
            Spacer(minLength: 0)
            
            CapsuleButton(
                content: {
                    HStack (alignment: .center, spacing: Constants.Design.spacing / 2) {
                        Image(systemName: "timer")
                        
                        if currentEditingState != .restTime {
                            Text(viewModel.defaultRestTime.duration.int.durationString())
                        } else {
                            Text(Constants.Placeholders.noDuration)
                        }
                    }
                },
                style: .secondary,
                isDisabled: Binding { isRestTimeEditDisabled } set: { _ in },
                action: {
                    switch currentEditingState {
                    case .none:
                        currentEditingState = .restTime
                    case .restTime:
                        currentEditingState = .none
                    default:
                        break
                    }
                }
            )
            
            Spacer(minLength: 0)
            
            IconButton(
                systemImage: "plus",
                style: .secondary,
                isDisabled: Binding { currentEditingState != .none } set: { _ in },
                action: {
                    coordinator.goToAddExercise()
                }
            )
        }
    }
    
    var isSaveButtonDisabled: Bool {
        currentEditingState == .name || currentEditingState == .restTime
    }
    
    var isRenameDisabled: Bool {
        currentEditingState == .list || currentEditingState == .restTime
    }
    
    var isRestTimeEditDisabled: Bool {
        currentEditingState == .name || currentEditingState == .list
    }
    
    var isListEditDisabled: Bool {
        viewModel.exercises.isEmpty
        || currentEditingState == .name
        || currentEditingState == .restTime
    }
    
    enum EditingState {
        case none
        case name
        case list
        case restTime
    }
}

struct WorkoutEditView_Previews: PreviewProvider {
    static var previews: some View {
        
        let persistenceController = PersistenceController.preview
        
        let collectionDataManager = CollectionDataManager()
        let firstCollection = collectionDataManager.fetchFirstUserCollection(in: persistenceController.container.viewContext)
        
        let workoutViewModel = WorkoutCollectionViewModel(context: persistenceController.container.viewContext, collectionUUID: firstCollection?.uuid)
        
        let workoutForPreview = collectionDataManager.fetchWorkouts(for: firstCollection!, in: workoutViewModel.mainContext).randomElement()!
        
        let workoutEditModel = WorkoutEditViewModel(parentViewModel: workoutViewModel, editingWorkoutUUID: workoutForPreview.uuid)!
        
        let workoutEditCoordinator = WorkoutEditCoordinator(viewModel: workoutEditModel)
        
        WorkoutEditView(viewModel: workoutEditModel)
            .environmentObject(workoutEditCoordinator)

    }
}
