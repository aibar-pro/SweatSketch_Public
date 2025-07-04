//
//  WorkoutEditorView.swift
//  MyWorkoutPlanner
//
//  Created by aibaranchikov on 24.11.2023.
//

import SwiftUI

struct WorkoutEditorView: View {
    @EnvironmentObject var coordinator: WorkoutEditCoordinator
    @ObservedObject var viewModel: WorkoutEditorModel
    
    @GestureState var titlePress = false
    
    @State private var currentEditingState: EditingState = .none
  
    @State private var phase: Phase = .showingList
    @State private var listOpacity: Double = 1
    
    var body: some View {
        VStack (alignment: .leading, spacing: Constants.Design.spacing) {
            headerView
            
            workoutNameView
                
            ZStack {
                if phase == .showingList {
                    ZStack {
                        exercisesView
                        
                        VStack {
                            if currentEditingState.isCurrent(.name) {
                                workoutNameEditView
                            }
                            
                            Spacer()
                            
                            if currentEditingState.isCurrent(.restTime) {
                                restTimeEditView
                            }
                        }
                    }
                    
                    .transition(.move(edge: .top))
                }
                
                if phase == .showingExercise {
                    Text("Exercise editing is not implemented yet")
                        .contentShape(Rectangle())
                        .transition(.move(edge: .top))
                        .onTapGesture {
                            animateExerciseSelection(revert: true)
                        }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .clipped()
            
            if phase == .showingList {
                footerView
                    .transition(.opacity)
            }
        }
        .padding(.vertical, Constants.Design.spacing / 2)
        .padding(.horizontal, Constants.Design.spacing)
    }
    
    private var headerView: some View {
        HStack(alignment: .center, spacing: Constants.Design.spacing) {
            CapsuleButton(
                "app.button.cancel.label",
                style: .inline,
                isDisabled: Binding { currentEditingState.isCurrent(.list) } set: { _ in },
                action: {
                    if currentEditingState.isCurrent(.none) {
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
                    if currentEditingState.isCurrent(.none) {
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
                    isDisabled: Binding { !viewModel.canUndo || !currentEditingState.isCurrent(.none) } set: { _ in },
                    action: {
                        viewModel.undo()
                    }
                )
                
                IconButton(
                    systemImage: "arrow.uturn.forward",
                    style: .inline,
                    isDisabled: Binding { !viewModel.canRedo || !currentEditingState.isCurrent(.none) } set : { _ in },
                    action: {
                        viewModel.redo()
                    }
                )
            }
        )
    }
    
    private var workoutNameView: some View {
        Text(viewModel.editingWorkout.name ?? Constants.Placeholders.noWorkoutName)
            .fullWidthText(.title2, isBold: !currentEditingState.isExerciseEditing)
            .lineLimit(3)
            .scaleEffect(titlePress ? 0.95 : 1)
            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: titlePress)
            .gesture(
                  LongPressGesture(minimumDuration: 0.35)
                      .updating($titlePress) { currentState, gestureState, transaction in
                          gestureState = currentState
                      }
                      .onEnded { value in
                          if currentEditingState.isCurrent(.none) {
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
            ForEach(viewModel.exercises.compactMap { $0.toExerciseRepresentation() }, id: \.id) { exercise in
                HStack (alignment: .firstTextBaseline, spacing: Constants.Design.spacing) {
                    ExerciseDetailView(exercise: exercise)
                    
                    Spacer(minLength: 0)
                    
                    if currentEditingState.isCurrent(.none) {
                        IconButton(
                            systemImage: "ellipsis",
                            style: .inline,
                            action: {
                                print("\(type(of: self)): Edit exercise: \(exercise.name)")
                                guard let exerciseEntityToEdit = viewModel.exercises.first(where: { $0.uuid == exercise.id }) else {
                                    print("\(type(of: self)): Could not find exercise to edit")
                                    return
                                }
//                                coordinator.goToEditExercise(exerciseToEdit: exerciseEntityToEdit)
                                animateExerciseSelection(uuid: exercise.id)
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
        .environment(
            \.editMode,
            .constant(
                currentEditingState.isCurrent(.list)
                ? EditMode.active
                : EditMode.inactive
            )
        )
        .animation(.easeInOut(duration: 0.25))
        .onChange(of: viewModel.exercises.count == 0) { _ in
            if currentEditingState.isCurrent(.list) {
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
                    if currentEditingState.isCurrent(.none) {
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
                        
                        if !currentEditingState.isCurrent(.restTime) {
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
                isDisabled: Binding { !currentEditingState.isCurrent(.none) } set: { _ in },
                action: {
//                    coordinator.goToAddExercise()
                    animateExerciseSelection()
                }
            )
        }
    }
    
    var isSaveButtonDisabled: Bool {
        currentEditingState.isCurrent(.name) || currentEditingState.isCurrent(.restTime)
    }
    
    var isRenameDisabled: Bool {
        currentEditingState.isCurrent(.list)
        || currentEditingState.isCurrent(.restTime)
        || currentEditingState.isExerciseEditing
    }
    
    var isRestTimeEditDisabled: Bool {
        currentEditingState.isCurrent(.name) || currentEditingState.isCurrent(.list)
    }
    
    var isListEditDisabled: Bool {
        viewModel.exercises.isEmpty
        || currentEditingState.isCurrent(.name)
        || currentEditingState.isCurrent(.restTime)
    }
    
    private func animateExerciseSelection(uuid: UUID? = nil, revert: Bool = false) {
        let animationDuration: Double = 0.35
        
        withAnimation(.smooth(duration: animationDuration)) {
            phase = .hidingList
            listOpacity = revert ? 1 : 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
            withAnimation(.smooth(duration: animationDuration)) {
                phase = revert ? .showingList : .showingExercise
                currentEditingState = revert ? .none : .exercise(uuid)
            }
        }
    }
    
    enum Phase: Equatable {
        case showingList, hidingList, showingExercise
    }
        
    enum EditingState {
        case none
        case name
        case list
        case restTime
        case exercise(UUID?)
        
        func isCurrent(_ state: EditingState) -> Bool {
            switch (self, state) {
            case (.name, .name), (.list, .list), (.restTime, .restTime), (.none, .none):
                return true
            case (.exercise(let lhs), .exercise(let rhs)):
                return lhs == rhs
            default:
                return false
            }
        }
        
        var isExerciseEditing: Bool {
            switch self {
            case .exercise:
                return true
            default:
                return false
            }
        }
    }
}

struct WorkoutEditView_Previews: PreviewProvider {
    static var previews: some View {
        
        let persistenceController = PersistenceController.preview
        
        let collectionDataManager = CollectionDataManager()
        let firstCollection = collectionDataManager.fetchFirstUserCollection(in: persistenceController.container.viewContext)
        
        let workoutViewModel = WorkoutCollectionViewModel(context: persistenceController.container.viewContext, collectionUUID: firstCollection?.uuid)
        
        let workoutForPreview = collectionDataManager.fetchWorkouts(for: firstCollection!, in: workoutViewModel.mainContext).randomElement()!
        
        let workoutEditModel = WorkoutEditorModel(parentViewModel: workoutViewModel, editingWorkoutUUID: workoutForPreview.uuid)!
        
        let workoutEditCoordinator = WorkoutEditCoordinator(viewModel: workoutEditModel)
        
        WorkoutEditorView(viewModel: workoutEditModel)
            .environmentObject(workoutEditCoordinator)

    }
}
