//
//  ExerciseEditorView.swift
//  MyWorkoutPlanner
//
//  Created by aibaranchikov on 12/5/21.
//

import SwiftUI

struct ExerciseEditorView: View {
    @EnvironmentObject var coordinator: WorkoutEditorCoordinator
    @ObservedObject var viewModel: ExerciseEditorModel

    @GestureState var isTitlePressed = false
    @State private var currentEditingState: EditingState = .none

    var body: some View {
        VStack(alignment: .leading, spacing: Constants.Design.spacing) {
            exerciseNameView
            
            actionsView
            
            buttonStackView
        }
    }

    private var exerciseNameView: some View {
        Text(viewModel.exercise.name ?? Constants.Placeholders.noExerciseName)
            .font(.title2.bold())
            .lineLimit(2)
            .scaleEffect(isTitlePressed ? 0.95 : 1)
            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isTitlePressed)
            .gesture(
                LongPressGesture(minimumDuration: 0.35)
                    .updating($isTitlePressed) { currentState, gestureState, transaction in
                        gestureState = currentState
                    }
                    .onEnded { value in
                        switchEditingState(to: .name)
                    }
            )
            .disabled(isRenameDisabled())
    }
    
    private var actionsView: some View {
        List {
            ForEach(
                viewModel.actions.compactMap { $0.toActionViewRepresentation() },
                id: \.id
            ) { action in
                HStack (alignment: .firstTextBaseline, spacing: Constants.Design.spacing) {
                    Text(action.type.description + " - \(action.title)")
                        .fullWidthText()
                    
                    Spacer(minLength: 0)
                    
                    if currentEditingState != .list {
                        IconButton(
                            systemImage: "ellipsis",
                            style: .inline,
                            action: {
//                                print("\(type(of: self)): Edit exercise: \(exercise.name)")
//                                guard let exerciseEntityToEdit = viewModel.exercises.first(where: { $0.uuid == exercise.id })
//                                else {
//                                    assertionFailure("Could not find exercise to edit")
//                                    return
//                                }
////                                coordinator.goToEditExercise(exerciseToEdit: exerciseEntityToEdit)
//                                coordinator.editExercise(exerciseEntityToEdit)
//                                animateExerciseSelection(uuid: exercise.id)
                            }
                        )
                    }
                }
                .padding(.vertical, Constants.Design.spacing / 2)
                .listRowBackground(Color.clear)
            }
//            .onDelete { index in viewModel.removeExercises(at: index) }
//            .onMove(perform: viewModel.reorderWorkoutExercise)
        }
        .opacity(isListEditDisabled ? 0.2 : 1)
        .disabled(isListEditDisabled)
        .listStyle(.plain)
        .listRowInsets(EdgeInsets())
        .materialCardBackgroundModifier()
        .environment(
            \.editMode,
            .constant(
                currentEditingState == .list
                ? EditMode.active
                : EditMode.inactive
            )
        )
        .animation(.easeInOut(duration: 0.25))
        .onChange(of: viewModel.actions.count == 0) { _ in
            switchEditingState(to: .none)
        }
    }
    
    private var buttonStackView: some View {
        HStack(alignment: .bottom, spacing: Constants.Design.spacing) {
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
            
            CapsuleButton(
                content: {
                    HStack (alignment: .center, spacing: Constants.Design.spacing / 4) {
                        Image(systemName: "timer")
                        
                        if currentEditingState != .rest {
                            DurationView(durationInSeconds: viewModel.restBetweenActions.duration.int)
                        } else {
                            Text(Constants.Placeholders.noDuration)
                        }
                    }
                },
                style: .secondary,
                isDisabled: Binding { isRestEditDisabled } set: { _ in },
                action: {
                    switchEditingState(to: .rest)
                }
            )

            Spacer(minLength: 0)
            
            IconButton(
                systemImage: "plus",
                style: .secondary,
                isDisabled: Binding { isAddButtonDisabled } set: { _ in },
                action: {
                    viewModel.addExerciseAction()
                    currentEditingState = .action
                }
            )
        }
    }
    
    private func isSaveButtonDisabled() -> Bool {
        return [.name, .action, .rest].contains(currentEditingState)
    }
    
    private var isAddButtonDisabled: Bool {
        return [.name, .rest, .list].contains(currentEditingState)
    }
    
    private var isListEditDisabled: Bool {
        return viewModel.actions.isEmpty || [.name, .action, .rest].contains(currentEditingState)
    }
    
//    private func isListDisabled() -> Bool {
//        return viewModel.exerciseActions.isEmpty || [.name, .rest].contains(currentEditingState)
//    }
    
    func isRenameDisabled() -> Bool {
        return currentEditingState == .list || [.action, .rest].contains(currentEditingState)
    }
    
    private var isRestEditDisabled: Bool {
        [.name, .action, .list].contains(currentEditingState)
    }
    
    private func switchEditingState(to state: EditingState) {
        guard currentEditingState != state else {
            currentEditingState = .none
            return
        }
        
        switch state {
        case .name:
            coordinator.presentBottomSheet(
                type: .singleTextField(
                    kind: .renameExercise,
                    initialText: viewModel.exercise.name ?? "",
                    action: { value in
                        viewModel.renameExercise(newName: value)
                        currentEditingState = .none
                    }, cancel: {
                        currentEditingState = .none
                    }
                )
            )
        case .rest:
            coordinator.presentBottomSheet(
                type: .timePicker(
                    kind: .exercise,
                    initialValue: viewModel.restBetweenActions.duration.int,
                    action: { value in
                        viewModel.setRestBetweenActions(duration: value)
                        currentEditingState = .none
                    },
                    cancel: {
                        currentEditingState = .none
                    }
                )
            )
        default:
            break
        }
        currentEditingState = state
    }
    
    enum EditingState {
        case none
        case name
        case list
        case action
        case rest
    }
}

struct ExerciseEditView_Previews: PreviewProvider {
    static var previews: some View {
        
        let persistenceController = PersistenceController.preview
        
        let collectionDataManager = CollectionDataManager()
        let firstCollection = collectionDataManager.fetchFirstUserCollection(in: persistenceController.container.viewContext)!
        
        let workoutCarouselViewModel = WorkoutCollectionViewModel(context: persistenceController.container.viewContext, collectionUUID: firstCollection.uuid)
        
        let workoutForPreview = collectionDataManager.fetchWorkouts(for: firstCollection, in: workoutCarouselViewModel.mainContext).first!
        let workoutEditModel = WorkoutEditorModel(parentViewModel: workoutCarouselViewModel, editingWorkoutUUID: workoutForPreview.uuid)!
        
        let workoutDataManager = WorkoutDataManager()
        let exerciseForPreview = try! workoutDataManager.fetchExercises(for: workoutForPreview, in: workoutEditModel.mainContext).get().randomElement()!
        
        let exerciseEditViewModel = ExerciseEditorModel(parent: workoutEditModel, exerciseId: exerciseForPreview.uuid)!
        
        ExerciseEditorView(viewModel: exerciseEditViewModel)
    }
}
