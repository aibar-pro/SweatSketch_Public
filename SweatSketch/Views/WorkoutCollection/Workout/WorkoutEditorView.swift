//
//  WorkoutEditorView.swift
//  MyWorkoutPlanner
//
//  Created by aibaranchikov on 24.11.2023.
//

import SwiftUI

struct WorkoutEditorView: View {
    @EnvironmentObject var coordinator: WorkoutEditorCoordinator
    @ObservedObject var viewModel: WorkoutEditorModel
    
    @GestureState var titlePress = false
    
    @State private var currentEditingState: EditingState = .none
  
    @State private var showExerciseEditor: Bool = false
    @State private var showListEditor: Bool = true
    @State private var listOpacity: Double = 1
    
    var body: some View {
        VStack (alignment: .leading, spacing: Constants.Design.spacing) {
            headerView
            
            workoutNameView
                
            ZStack {
                if showListEditor {
                    exercisesView
                        .transition(.move(edge: .top))
                }
                
                if showExerciseEditor,
                    let eeModel = coordinator.exerciseEditorModel {
                    ExerciseEditorView(viewModel: eeModel)
                        .transition(.move(edge: .top))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .clipped()
            
            if showListEditor {
                footerView
                    .transition(.opacity)
            }
        }
        .padding(.vertical, Constants.Design.spacing / 2)
        .padding(.horizontal, Constants.Design.spacing)
    }
    
    private var headerView: some View {
        ZStack {
            HStack(alignment: .center, spacing: Constants.Design.spacing) {
                undoButton
                redoButton
            }
            
            HStack(alignment: .center, spacing: Constants.Design.spacing) {
                CapsuleButton(
                    "app.button.cancel.label",
                    style: .inline,
                    isDisabled: Binding { currentEditingState.isCurrent(.list) } set: { _ in },
                    action: cancelEditing
                )
                
                Spacer(minLength: 0)
                
                CapsuleButton(
                    "app.button.save.label",
                    style: .primary,
                    isDisabled: Binding { isSaveButtonDisabled } set: { _ in },
                    action: commitEditing
                )
            }
        }
    }
    
    private var undoButton: some View {
        IconButton(
            systemImage: "arrow.uturn.backward",
            style: .inline,
            isDisabled: Binding {
                !(coordinator.activeUndoTarget?.canUndo ?? false)
            } set: { _ in },
            action: {
                coordinator.activeUndoTarget?.undo()
            }
        )
    }
    
    private var redoButton: some View {
        IconButton(
            systemImage: "arrow.uturn.forward",
            style: .inline,
            isDisabled: Binding {
                !(coordinator.activeUndoTarget?.canRedo ?? false)
            } set: { _ in },
            action: {
                coordinator.activeUndoTarget?.redo()
            }
        )
    }
    
    private var workoutNameView: some View {
        Text(viewModel.editingWorkout.name ?? Constants.Placeholders.noWorkoutName)
            .fullWidthText(
                showListEditor ? .title2 : .title3,
                isBold: showListEditor
            )
            .lineLimit(3)
            .scaleEffect(titlePress ? 0.95 : 1)
            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: titlePress)
            .highPriorityGesture(
                TapGesture()
                    .onEnded { _ in
                        if currentEditingState.isExerciseEditing {
                            cancelExerciseEditing()
                        }
                    }
            )
            .simultaneousGesture(
                LongPressGesture(minimumDuration: 0.35)
                    .updating($titlePress) { value, state, _ in state = value }
                    .onEnded { _ in
                        if currentEditingState.isCurrent(.none) {
                            switchEditingState(to: .name)
                        }
                    }
            )
//            .disabled(isRenameDisabled)
    }
    
    
    private var exercisesView: some View {
        List {
            ForEach(viewModel.exercises.compactMap { $0.toExerciseRepresentation() }, id: \.id) { exercise in
                HStack(alignment: .firstTextBaseline, spacing: Constants.Design.spacing) {
                    ExerciseDetailView(exercise: exercise)
                    
                    Spacer(minLength: 0)
                    
                    if !currentEditingState.isCurrent(.list) {
                        IconButton(
                            systemImage: "ellipsis",
                            style: .inline,
                            isDisabled: Binding { !currentEditingState.isCurrent(.none) } set: { _ in },
                            action: {
                                switchEditingState(to: .exercise(exercise.id))
                            }
                        )
                    }
                }
                .padding(.vertical, Constants.Design.spacing / 2)
                .listRowBackground(Color.clear)
            }
            .onDelete { index in viewModel.removeExercises(at: index) }
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

    private var footerView: some View {
        HStack (alignment: .bottom, spacing: Constants.Design.spacing) {
            IconButton(
                systemImage: "arrow.up.arrow.down",
                style: .secondary,
                isDisabled: Binding { isListEditDisabled } set: { _ in },
                action: {
                    switchEditingState(to: .list)
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
                    switchEditingState(to: .restTime)
                }
            )
            
            Spacer(minLength: 0)
            
            IconButton(
                systemImage: "plus",
                style: .secondary,
                isDisabled: Binding { !currentEditingState.isCurrent(.none) } set: { _ in },
                action: {
                    switchEditingState(to: .exercise())
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
        let animationDuration: Double = 0.5
        
        withAnimation(
            .easeIn(duration: animationDuration)
        ) {
            if revert {
                showExerciseEditor = false
            } else {
                showListEditor = false
            }
//            listOpacity = revert ? 1 : 0
        }
        
        withAnimation(
            .easeIn(duration: animationDuration)
            .delay(animationDuration)
        ) {
            if revert {
                showListEditor = true
            } else {
                showExerciseEditor = true
            }
        }
    }
    
    private func switchEditingState(to state: EditingState) {
        guard !currentEditingState.isCurrent(state) else {
            currentEditingState = .none
            return
        }
        
        switch state {
        case .name:
            coordinator.presentBottomSheet(
                type: .singleTextField(
                    kind: .renameWorkout,
                    initialText: viewModel.editingWorkout.name ?? "",
                    action: {
                        viewModel.renameWorkout(newName: $0)
                        currentEditingState = .none
                    },
                    cancel: {
                        currentEditingState = .none
                    }
                )
            )
        case .exercise(let uuid):
            coordinator.beginExerciseEditing(uuid: uuid)
            animateExerciseSelection(uuid: uuid)
        case .restTime:
            coordinator.presentBottomSheet(
                type: .timePicker(
                    kind: .workout,
                    initialValue: viewModel.defaultRestTime.duration.int,
                    action: { value in
                        viewModel.updateDefaultRestTime(duration: value)
                        currentEditingState = .none
                    },
                    cancel: {
                        currentEditingState = .none
                    }
//                    advancedEditor: {
//                        coordinator.goToAdvancedEditRestPeriod()
//                        currentEditingState = .none
//                    }
                )
            )
        default:
            break
        }
        currentEditingState = state
    }
    
    private func cancelEditing() {
        switch currentEditingState {
        case .none:
            coordinator.discardWorkoutEdit()
        case .exercise:
            cancelExerciseEditing()
        default:
            switchEditingState(to: .none)
        }
    }
    
    private func cancelExerciseEditing() {
        guard case .exercise = currentEditingState else {
            return
        }
        coordinator.endExerciseEditing(shouldCommit: false)
        animateExerciseSelection(revert: true)
        switchEditingState(to: .none)
    }
    
    private func commitEditing() {
        switch currentEditingState {
        case .none:
            coordinator.saveWorkoutEdit()
        case .exercise:
            coordinator.endExerciseEditing(shouldCommit: true)
            animateExerciseSelection(revert: true)
            switchEditingState(to: .none)
        default:
            switchEditingState(to: .none)
        }
    }
    
    enum EditingState {
        case none
        case name
        case list
        case restTime
        case exercise(UUID? = nil)
        
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
        
        let workoutEditCoordinator = WorkoutEditorCoordinator(viewModel: workoutEditModel)
        
        WorkoutEditorView(viewModel: workoutEditModel)
            .environmentObject(workoutEditCoordinator)
    }
}
