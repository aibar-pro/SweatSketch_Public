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
        Group {
            VStack(alignment: .leading, spacing: Constants.Design.spacing) {
                exerciseNameView
                
                actionsView
                
                buttonStackView
            }
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
            ForEach(viewModel.actions, id: \.id) { action in
                HStack (alignment: .firstTextBaseline, spacing: Constants.Design.spacing) {
                    ActionDetailView(action: action)
                    
                    Spacer(minLength: 0)
                    
                    if !currentEditingState.isOne(of: .list) {
                        IconButton(
                            systemImage: "ellipsis",
                            style: .inline,
                            action: {
                                switchEditingState(to: .action(action.entityUUID))
                            }
                        )
                    }
                }
                .padding(.vertical, Constants.Design.spacing / 2)
                .listRowBackground(Color.clear)
            }
            .onDelete(perform: viewModel.deleteActions)
            .onMove(perform: viewModel.moveActions)
        }
        .opacity(isListEditDisabled ? 0.2 : 1)
        .disabled(isListEditDisabled)
        .listStyle(.plain)
        .listRowInsets(EdgeInsets())
        .adaptiveScrollIndicatorsHidden()
        .materialBackground()
        .lightShadow()
        .environment(
            \.editMode,
            .constant(
                currentEditingState.isOne(of: .list)
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
                    switchEditingState(to: .list)
                }
            )
            
            CapsuleButton(
                content: {
                    HStack (alignment: .center, spacing: Constants.Design.spacing / 4) {
                        Image(systemName: "timer")
                        
                        if !currentEditingState.isOne(of: .rest) {
                            DurationView(durationInSeconds: viewModel.restBetweenActions)
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
            
            CapsuleButton(
                content: {
                    HStack (alignment: .center, spacing: Constants.Design.spacing / 4) {
                        Image(systemName: "repeat")
                        
                        Text(String(viewModel.exercise.superSets))
                    }
                },
                style: .secondary,
                isDisabled: Binding { isSetsEditDisabled } set: { _ in },
                action: {
                    switchEditingState(to: .sets)
                }
            )

            Spacer(minLength: 0)
            
            IconButton(
                systemImage: "plus",
                style: .secondary,
                isDisabled: Binding { isAddButtonDisabled } set: { _ in },
                action: {
                    switchEditingState(to: .action())
                }
            )
        }
    }
    
    private func switchEditingState(to state: EditingState) {
        guard !currentEditingState.isOne(of: state) else {
            currentEditingState = .none
            return
        }
        
        switch state {
        case .name:
            presentRenameSheet()
        case .rest:
            presentRestSheet()
        case .action(let id):
            presentActionSheet(id)
        case .sets:
            presentSetsSheet()
        default:
            break
        }
        currentEditingState = state
    }
    
    private func presentRenameSheet() {
        coordinator.presentExerciseRenameSheet(
            onSubmit: { value in
                viewModel.renameExercise(newName: value)
                currentEditingState = .none
            },
            onDismiss: {
                currentEditingState = .none
            }
        )
    }
    
    private func presentRestSheet() {
        coordinator.presentExerciseRestSheet(
            onSubmit: { value in
                viewModel.setRestBetweenActions(duration: value)
                currentEditingState = .none
            },
            onDismiss: {
                currentEditingState = .none
            }
        )
    }
    
    private func presentActionSheet(_ actionId: UUID?) {
        viewModel.prepareActionForEditing(actionId)
        
        guard let actionDraft = viewModel.actionDraft
        else {
            currentEditingState = .none
            return
        }
        
        coordinator.presentExerciseActionSheet(
            for: actionDraft,
            onSubmit: { value in
                viewModel.commitActionDraft(value)
                currentEditingState = .none
                print("\(type(of: self)): Save action")
            },
            onDismiss: {
                currentEditingState = .none
                print("\(type(of: self)): Discard action edits")
            }
        )
    }
    
    private func presentSetsSheet() {
        coordinator.presentExerciseRepetitionsSheet(
            onSubmit: { value in
                viewModel.setSupersets(count: value)
                currentEditingState = .none
            },
            onDismiss: {
                currentEditingState = .none
            }
        )
    }
    
    private var isAddButtonDisabled: Bool {
        !currentEditingState.isOne(of: .action(), .none)
    }
    
    private var isListEditDisabled: Bool {
        viewModel.actions.isEmpty || !currentEditingState.isOne(of: .list, .none)
    }
    
    func isRenameDisabled() -> Bool {
        !currentEditingState.isOne(of: .name, .none)
    }
    
    private var isRestEditDisabled: Bool {
        !currentEditingState.isOne(of: .rest, .none)
    }
    
    private var isSetsEditDisabled: Bool {
        !currentEditingState.isOne(of: .sets, .none)
    }
    
    enum EditingState: CaseMatchable {
        case none
        case name
        case list
        case action(UUID? = nil)
        case rest
        case sets
        
        internal func matchesCase(_ other: ExerciseEditorView.EditingState) -> Bool {
            switch (self, other) {
            case (.none, .none), (.name, .name), (.rest, .rest), (.list, .list), (.action, .action), (.sets, .sets):
                return true
            default:
                return false
            }
        }
    }
}

struct ExerciseEditView_Previews: PreviewProvider {
    static var previews: some View {
        
        let persistenceController = PersistenceController.preview
        
        let collectionDataManager = CollectionDataManager()
        let firstCollection = collectionDataManager.fetchFirstUserCollection(in: persistenceController.container.viewContext)!
        
        let workoutCarouselViewModel = WorkoutCollectionViewModel(context: persistenceController.container.viewContext, collectionUUID: firstCollection.uuid)
        
        let workoutForPreview = collectionDataManager.fetchWorkouts(for: firstCollection, in: workoutCarouselViewModel.context).first!
        let workoutEditModel = WorkoutEditorModel(parent: workoutCarouselViewModel, editingWorkoutUUID: workoutForPreview.uuid)!
        
        let workoutDataManager = WorkoutDataManager()
        let exerciseForPreview = try! workoutDataManager.fetchExercises(for: workoutForPreview, in: workoutEditModel.context).get().randomElement()!
        
        let exerciseEditViewModel = ExerciseEditorModel(parent: workoutEditModel, exerciseId: exerciseForPreview.uuid)!
        
        ExerciseEditorView(viewModel: exerciseEditViewModel)
    }
}
