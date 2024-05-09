//
//  ActionListEditView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 11.04.2024.
//

import SwiftUI

struct ActionListEditView: View {
    @ObservedObject var viewModel: ExerciseEditViewModel
    
    @Binding var currentEditingState: ExerciseEditView.EditingState
    
    var body: some View {
        GeometryReader { listGeo in
            ScrollViewReader { scrollProxy in
                List {
                    ForEach(viewModel.editingExerciseActions.filter { action in
                        switch ExerciseType.from(rawValue: viewModel.editingExercise.type) {
                        case .setsNreps:
                            return ExerciseActionType.from(rawValue: action.type) == .setsNreps
                        case .timed:
                            return ExerciseActionType.from(rawValue: action.type) == .timed
                        case .mixed:
                            return [.setsNreps, .timed].contains(ExerciseActionType.from(rawValue: action.type))
                        case .unknown:
                            return ExerciseActionType.from(rawValue: action.type) == .unknown
                        }
                    }, id: \.self)
                    { action in
                        let isEditingBinding = Binding<Bool>(
                            get: {
                                viewModel.isEditingAction(action)
                            },
                            set: { isEditing in
                                if isEditing {
                                    viewModel.setEditingAction(action)
                                    currentEditingState = .action
                                } else {
                                    viewModel.clearEditingAction()
                                    currentEditingState = .none
                                }
                            }
                        )
                        
                        HStack (alignment: .center) {
                            let exerciseType = ExerciseType.from(rawValue: viewModel.editingExercise.type)
                            
                            ActionEditSwitchView(actionEntity: action, isEditing: isEditingBinding, exerciseType: exerciseType) {
                                type in
                                viewModel.setEditingActionType(to: type)
                            }
                            .frame(height:  listGeo.size.height/getRowHeightMultiplier(exerciseType: exerciseType, actionType: ExerciseActionType.from(rawValue: action.type), actionIsEditing: viewModel.isEditingAction(action)))
                            
                            Spacer()
                            
                            Button(action: {
                                if currentEditingState == .action, viewModel.isEditingAction(action) {
                                    viewModel.clearEditingAction()
                                    currentEditingState = .none
                                } else {
                                    viewModel.setEditingAction(action)
                                    currentEditingState = .action
                                }
                            }) {
                                if currentEditingState == .action, viewModel.isEditingAction(action) {
                                    Text("Done")
                                        .padding(Constants.Design.spacing/2)
                                } else {
                                    Image(systemName: "ellipsis")
                                }
                            }
                            .disabled(isRowEditDisable())
                        }
                        .id(action.objectID)
                        .padding(.horizontal, Constants.Design.spacing/2)
                        .padding(.vertical, Constants.Design.spacing)
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: Constants.Design.cornerRadius, style: .continuous)
                                .fill(
                                    Color.clear
                                )
                                .materialCardBackgroundModifier()
                                .padding(.all, Constants.Design.spacing/2)
                        )
                    }
                    .onMove(perform: viewModel.moveExerciseActions)
                    .onDelete(perform: viewModel.deleteExerciseActions)
                }
                .opacity(isListDisabled() ? 0.2 : 1)
                .disabled(isListDisabled())
                .listStyle(.plain)
                .environment(\.editMode,
                              .constant(currentEditingState == .list ? EditMode.active : EditMode.inactive))
                .animation(.easeInOut(duration: 0.25))
                .onChange(of: viewModel.editingAction) { _ in
                    if let actionID = viewModel.editingAction?.objectID {
                        withAnimation {
                            scrollProxy.scrollTo(actionID, anchor: .bottom)
                        }
                    }
                }
                .onChange(of: viewModel.editingAction?.type) { _ in
                    if let actionID = viewModel.editingAction?.objectID {
                        withAnimation {
                            scrollProxy.scrollTo(actionID, anchor: .bottom)
                        }
                    }
                }
                .onChange(of: viewModel.editingExerciseActions.count==0, perform: { _ in
                    if currentEditingState == .list {
                        currentEditingState = .none
                    }
                })
            }
        }
    }
    
    private func isRowEditDisable() -> Bool {
        return [.name, .rest, .list].contains(currentEditingState)
    }
    
    private func isListDisabled() -> Bool {
        return viewModel.editingExerciseActions.isEmpty || [.name, .rest].contains(currentEditingState)
    }
    
    private func getRowHeightMultiplier(exerciseType: ExerciseType, actionType: ExerciseActionType, actionIsEditing: Bool) -> CGFloat {
        if currentEditingState == .list { return 20 }
        
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

struct ActionListEditView_Previews: PreviewProvider {
    static var previews: some View {
        
        let persistenceController = PersistenceController.preview
        
        let collectionDataManager = CollectionDataManager()
        let firstCollection = collectionDataManager.fetchFirstUserCollection(in: persistenceController.container.viewContext)!
        
        let workoutCarouselViewModel = WorkoutCollectionViewModel(context: persistenceController.container.viewContext, collectionUUID: firstCollection.uuid)
        
        let workoutForPreview = collectionDataManager.fetchWorkouts(for: firstCollection, in: workoutCarouselViewModel.mainContext).first!
        let workoutEditModel = WorkoutEditViewModel(parentViewModel: workoutCarouselViewModel, editingWorkoutUUID: workoutForPreview.uuid)
        
        let workoutDataManager = WorkoutDataManager()
        let exerciseForPreview = workoutDataManager.fetchExercises(for: workoutForPreview, in: workoutEditModel.mainContext)[2]
        
        let exerciseEditViewModel = ExerciseEditViewModel(parentViewModel: workoutEditModel, editingExercise: exerciseForPreview)
        let exerciseCoordinator = ExerciseEditCoordinator(viewModel: exerciseEditViewModel)
        
        ActionListEditView(viewModel: exerciseEditViewModel, currentEditingState: .constant(.none))
            .environmentObject(exerciseCoordinator)
    }
}
