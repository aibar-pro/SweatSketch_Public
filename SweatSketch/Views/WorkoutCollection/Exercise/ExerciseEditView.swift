//
//  ExerciseView.swift
//  MyWorkoutPlanner
//
//  Created by aibaranchikov on 12/5/21.
//

import SwiftUI

struct ExerciseEditorView: View {
    @ObservedObject var viewModel: ExerciseEditorModel

    @GestureState var titlePress = false
    
    enum EditingState {
        case none
        case name
        case list
        case action
        case rest
    }
    @State private var currentEditingState: EditingState = .none

    var body: some View {
        ZStack {
            WorkoutPlanningModalBackgroundView()
            
            VStack(alignment: .leading, spacing: Constants.Design.spacing) {
//                headerView
                
                exerciseNameView
                
                ZStack {
                    VStack (alignment: .leading, spacing: Constants.Design.spacing/2) {
//                        if currentEditingState != .list {
//                            
//                            Picker("Type", selection:
//                                    Binding(get: { ExerciseType.from(rawValue: self.viewModel.editingExercise.type) }, set: { self.viewModel.setEditingExerciseType(to: $0) }
//                                           )) {
//                                ForEach(ExerciseType.exerciseTypes, id: \.self) { type in
//                                    Text(type.screenTitle)
//                                    
//                                }
//                            }
//                            .disabled(currentEditingState != .none)
//                            .pickerStyle(.segmented)
//                            .padding(.horizontal, Constants.Design.spacing)
//                            .padding(.bottom, Constants.Design.spacing/2)
//                            
//                            if ExerciseType.from(rawValue: viewModel.editingExercise.type) == .mixed {
//                                HStack {
//                                    Text(Constants.Placeholders.WorkoutCollection.supersetCountLabel)
//                                        .opacity(currentEditingState != .none ? 0.3 : 1)
//                                    
//                                    Picker("Superset reps", selection: Binding(
//                                        get: { Int(viewModel.editingExercise.superSets)},
//                                        set: { viewModel.setSupersets(count: $0)}))
//                                    {
//                                        ForEach(1...99, id: \.self) {
//                                            Text("\($0)")
//                                        }
//                                    }
//                                    .labelsHidden()
//                                    .pickerStyle(.menu)
//                                }
//                                .disabled(currentEditingState != .none)
//                                .padding(.horizontal, Constants.Design.spacing)
//                                .padding(.bottom, Constants.Design.spacing/2)
//                            }
//                        }
//                            let isRowEditDisabled = Binding<Bool>(
//                                isRowEditDisable())
                        
                        
                        ActionListEditView(viewModel: viewModel, currentEditingState: $currentEditingState)
                    }
                    VStack {
                        if currentEditingState == .name {
                            exerciseNameEditView
                        }
                        Spacer()
                        
                        if currentEditingState == .rest {
                            WorkoutRestTimeView(
                                onSave: { newDuration in
                                    viewModel.setRestTimeBetweenActions(newDuration: newDuration)
                                    currentEditingState = .none
                                },
                                onDiscard: {
                                    currentEditingState = .none
                                },
                                duration: viewModel.restBetweenActions.duration.int
                            )
                            .padding(Constants.Design.spacing)
                            .materialCardBackgroundModifier()
                        }
                    }
                }
                
                buttonStackView
            }
            .padding(.horizontal, Constants.Design.spacing)
            .padding(.top, Constants.Design.spacing / 2)
            .customAccentColorModifier(Constants.Design.Colors.textColorHighEmphasis)
        }
    }
//    
//    private var headerView: some View {
//        HStack(alignment: .center, spacing: Constants.Design.spacing) {
//            Button(action: {
//                switch currentEditingState {
//                case .none:
//                    print("Exercise DISCARD")
//                    coordinator.discardExerciseEdit()
//                case .action:
//                    viewModel.clearEditingAction()
//                    currentEditingState = .none
//                default:
//                    currentEditingState = .none
//                }
//            }) {
//                Text("app.button.cancel.label")
//                    .padding(.vertical, Constants.Design.spacing / 2)
//                    .padding(.trailing, Constants.Design.spacing / 2)
//            }
//            .disabled(currentEditingState == .list)
//            
//            Spacer(minLength: 0)
//            
//            Button(action: {
//                switch currentEditingState {
//                case .none:
//                    print("Exercise SAVE")
//                    coordinator.saveExerciseEdit()
//                case .action:
//                    viewModel.clearEditingAction()
//                    currentEditingState = .none
//                default:
//                    currentEditingState = .none
//                }
//            }) {
//                Text(
//                    currentEditingState == .list
//                    ? "app.button.done.label"
//                    : "app.button.save.label"
//                )
//                .bold()
//                .padding(.vertical, Constants.Design.spacing / 2)
//                .padding(.leading, Constants.Design.spacing / 2)
//            }
//            .disabled(isSaveButtonDisabled())
//        }
//    }
    
    private var exerciseNameView: some View {
        Text(viewModel.exercise.name ?? Constants.Placeholders.noExerciseName)
            .font(.title2.bold())
            .lineLimit(2)
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
    }
    
    private var exerciseNameEditView: some View {
        TextFieldPopoverView(
            popoverTitle: Constants.Placeholders.WorkoutCollection.renameExercisePopupTitle,
            textFieldLabel: Constants.Placeholders.renamePopupText,
            buttonLabel: Constants.Placeholders.renamePopupButtonLabel,
            onDone: { newName in
                viewModel.renameExercise(newName: newName)
                currentEditingState = .none
            }, onDiscard: {
                currentEditingState = .none
            }
        )
    }
    
    private var buttonStackView: some View {
        HStack(alignment: .bottom, spacing: Constants.Design.spacing) {
            IconButton(
                systemImage: "arrow.up.arrow.down",
                style: .secondary,
                action: {
                    if currentEditingState == .none {
                        currentEditingState = .list
                    } else {
                        currentEditingState = .none
                    }
                }
            )
            .disabled(isListEditDisabled())
            
            Button(action: {
                switch currentEditingState {
                case .none:
                    currentEditingState = .rest
                case .rest:
                    currentEditingState = .none
                default:
                    break
                }
            }) {
                HStack (alignment: .center, spacing: Constants.Design.spacing / 4) {
                    Image(systemName: "timer")
                    
                    if currentEditingState != .rest {
                        DurationView(durationInSeconds: viewModel.restBetweenActions.duration.int)
                    } else {
                        Text(Constants.Placeholders.noDuration)
                    }
                }
                .padding(Constants.Design.spacing / 4)
            }
            .disabled(isRestEditDisabled())
            
            Spacer(minLength: 0)
            
            Button(action: {
                viewModel.addExerciseAction()
                currentEditingState = .action
            }) {
                Image(systemName: "plus")
                    .font(.title2.bold())
                    .primaryButtonLabelStyleModifier()
            }
            .disabled(isAddButtonDisabled())
        }
    }
    
    private func isSaveButtonDisabled() -> Bool {
        return [.name, .action, .rest].contains(currentEditingState)
    }
    
    private func isAddButtonDisabled() -> Bool {
        return [.name, .rest, .list].contains(currentEditingState)
    }
    
    private func isListEditDisabled() -> Bool {
        return viewModel.actions.isEmpty || [.name, .action, .rest].contains(currentEditingState)
    }
    
//    private func isListDisabled() -> Bool {
//        return viewModel.exerciseActions.isEmpty || [.name, .rest].contains(currentEditingState)
//    }
    
    func isRenameDisabled() -> Bool {
        return currentEditingState == .list || [.action, .rest].contains(currentEditingState)
    }
    
    func isRestEditDisabled() -> Bool {
        return currentEditingState == .list || [.name, .action].contains(currentEditingState)
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
        
        let exerciseEditViewModel = ExerciseEditorModel(parentViewModel: workoutEditModel, editingExercise: exerciseForPreview)!
        
        ExerciseEditorView(viewModel: exerciseEditViewModel)
    }
}
