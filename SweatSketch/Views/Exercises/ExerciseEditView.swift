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
            BackgroundGradientView()
            
            GeometryReader { geoReader in
               
                VStack (alignment: .leading) {
                    HStack {
                        Button(action: {
                            switch currentEditingState {
                            case .none:
                                print("Exercise DISCARD")
                                coordinator.discardExerciseEdit()
                            case .name:
                                newExerciseName.removeAll()
                                currentEditingState = .none
                            case .action:
                                viewModel.clearEditingAction()
                                currentEditingState = .none
                            default:
                                currentEditingState = .none
                            }
                        }) {
                            Text("Cancel")
                                .padding(.vertical, Constants.Design.spacing/2)
                                .padding(.trailing, Constants.Design.spacing/2)
                        }
                        .disabled(currentEditingState == .list)
                        
                        Spacer()
                        
                        Button(action: {
                            switch currentEditingState {
                            case .none:
                                print("Exercise SAVE")
                                coordinator.saveExerciseEdit()
                            case .action:
                                viewModel.clearEditingAction()
                                currentEditingState = .none
                            default:
                                currentEditingState = .none
                            }
                        }) {
                            Text(currentEditingState == .list ? "Done" : "Save")
                                .bold()
                                .padding(.vertical, Constants.Design.spacing/2)
                                .padding(.leading, Constants.Design.spacing/2)
                            
                        }
                        .disabled(isSaveButtonDisable())
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
                            LongPressGesture(minimumDuration: 0.35)
                                .updating($titlePress) { currentState, gestureState, transaction in
                                    gestureState = currentState
                                }
                                .onEnded { value in
                                    if currentEditingState == .none {
                                        currentEditingState = .name
                                    } else {
                                        newExerciseName.removeAll()
                                        currentEditingState = .none
                                    }
                                }
                        )
                        .disabled(isRenameDisabled())
                    
                    ZStack {
                        VStack (alignment: .leading, spacing: Constants.Design.spacing/2) {
                            if currentEditingState != .list {
                                
                                Picker("Type", selection:
                                        Binding(get: { ExerciseType.from(rawValue: self.viewModel.editingExercise?.type) }, set: { self.viewModel.setEditingExerciseType(to: $0) }
                                               )) {
                                    ForEach(ExerciseType.exerciseTypes, id: \.self) { type in
                                        Text(type.screenTitle)
                                        
                                    }
                                }
                                               .disabled(currentEditingState != .none)
                                               .pickerStyle(.segmented)
                                               .padding(.horizontal, Constants.Design.spacing)
                                               .padding(.bottom, Constants.Design.spacing/2)
                                
                                if ExerciseType.from(rawValue: viewModel.editingExercise?.type) == .mixed {
                                    HStack {
                                        Text("Superset repetitions:")
                                            .opacity(currentEditingState != .none ? 0.3 : 1)
                                        
                                        Picker("Superset reps", selection: Binding(
                                            get: { Int(viewModel.editingExercise?.superSets ?? 1)},
                                            set: { viewModel.setSupersets(superset: $0)}))
                                        {
                                            ForEach(1...99, id: \.self) {
                                                Text("\($0)")
                                            }
                                        }
                                        .labelsHidden()
                                        .pickerStyle(.menu)
                                    }
                                    .disabled(currentEditingState != .none)
                                    .padding(.horizontal, Constants.Design.spacing)
                                    .padding(.bottom, Constants.Design.spacing/2)
                                }
                            }
                            GeometryReader { listGeo in
                                ScrollViewReader { scrollProxy in
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
                                                        print("binding \(currentEditingState)")
                                                    } else {
                                                        viewModel.clearEditingAction()
                                                        currentEditingState = .none
                                                        print("binding \(currentEditingState)")
                                                    }
                                                }
                                            )
                                            
                                            HStack (alignment: .center) {
                                                let exerciseType = ExerciseType.from(rawValue: viewModel.editingExercise?.type)
                                                
                                                ActionEditSwitchView(actionEntity: action, isEditing: isEditingBinding, exerciseType: exerciseType) {
                                                    type in
                                                    viewModel.setEditingActionType(to: type)
                                                }
                                                .frame(height:  listGeo.size.height/getRowHeightMultiplier(exerciseType: exerciseType, actionType: ExerciseActionType.from(rawValue: action.type), actionIsEditing: isEditingBinding.wrappedValue))
                                                Spacer()
                                                if viewModel.editingAction == nil {
                                                    Button(action: {
                                                        if viewModel.editingAction == action {
                                                            viewModel.editingAction = nil
                                                            currentEditingState = .none
                                                            print("button \(currentEditingState)")
                                                        } else {
                                                            viewModel.setEditingAction(action)
                                                            currentEditingState = .action
                                                            scrollProxy.scrollTo(action)
                                                            print("button \(currentEditingState)")
                                                        }
                                                    }) {
                                                        Image(systemName: "ellipsis")
                                                    }
                                                    .disabled(currentEditingState != .none)
                                                }
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
                                        if let latestActionID = viewModel.editingAction?.objectID {
                                            withAnimation {
                                                scrollProxy.scrollTo(latestActionID, anchor: .bottom)
                                            }
                                        }
                                    }
                                    .onChange(of: viewModel.editingAction?.type) { _ in
                                        if let latestActionID = viewModel.editingAction?.objectID {
                                            withAnimation {
                                                scrollProxy.scrollTo(latestActionID, anchor: .bottom)
                                            }
                                        }
                                    }
                                    .onChange(of: viewModel.exerciseActions.count==0, perform: { _ in
                                        if currentEditingState == .list {
                                            currentEditingState = .none
                                        }
                                    })
                                }
                            }
                        }
                        VStack {
                            if currentEditingState == .name {
                                VStack (alignment: .leading, spacing: Constants.Design.spacing) {
                                    HStack {
                                        Text("New exercise name")
                                            .font(.title3.bold())
                                        Spacer()
                                        Button(action: {
                                            newExerciseName.removeAll()
                                            currentEditingState = .none
                                        }) {
                                            Image(systemName: "xmark")
                                        }
                                    }
                                    
                                    TextField("New exercise name", text: $newExerciseName)
                                        .padding(.horizontal, Constants.Design.spacing/2)
                                        .padding(.vertical, Constants.Design.spacing)
                                        .background(
                                            RoundedRectangle(cornerRadius: Constants.Design.cornerRadius)
                                                .stroke(Constants.Design.Colors.backgroundStartColor)
                                        )
                                    
                                    HStack (spacing: Constants.Design.spacing) {
                                        Spacer()
                                        Button(action: {
                                            newExerciseName.removeAll()
                                            currentEditingState = .none
                                        }) {
                                            Text("Cancel")
                                                .secondaryButtonLabelStyleModifier()
                                        }
                                        Button(action: {
                                            viewModel.renameExercise(newName: newExerciseName)
                                            newExerciseName.removeAll()
                                            currentEditingState = .none
                                        }) {
                                            Text("Rename")
                                                .bold()
                                                .primaryButtonLabelStyleModifier()
                                        }
                                        .disabled(newExerciseName.isEmpty)
                                    }
                                }
                                .padding(Constants.Design.spacing)
                                .materialCardBackgroundModifier()
                                .padding(.horizontal, Constants.Design.spacing)
                            }
                            Spacer()
                            
                            if currentEditingState == .rest {
                                if let exerciseRestTime = viewModel.restTime {
                                    ExerciseRestTimePopoverView(restActionEntity: exerciseRestTime, showPopover: Binding(
                                        get: {
                                            switch currentEditingState {
                                            case .rest:
                                                return true
                                            default:
                                                return false
                                            }
                                        },
                                        set: {_ in
                                            currentEditingState = .none
                                        }))
                                    .padding(Constants.Design.spacing)
                                    .materialCardBackgroundModifier()
                                }
                            }
                        }
                    }
                    
                    HStack {
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
                                currentEditingState = .rest
                            case .rest:
                                currentEditingState = .none
                            default:
                                break
                            }
                        }) {
                            HStack (alignment: .center, spacing: Constants.Design.spacing/4) {
                                Image(systemName: "timer")
                                
                                if let exerciseRestTime = viewModel.restTime, currentEditingState != .rest {
                                    DurationView(durationInSeconds: Int(exerciseRestTime.duration))
                                } else {
                                    Text(Constants.Design.Placeholders.noDuration)
                                }
                            }
                            .padding(Constants.Design.spacing/2)
                        }
                        .disabled(isRestEditDisabled())
                        
                        Spacer()
                        
                        Button(action: {
                            viewModel.addExerciseAction()
                            currentEditingState = .action
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
    
    private func isSaveButtonDisable() -> Bool {
        return [.name, .action, .rest].contains(currentEditingState)
    }
    
    private func isListEditDisabled() -> Bool {
        return viewModel.exerciseActions.isEmpty || [.name, .action, .rest].contains(currentEditingState)
    }
    
    private func isListDisabled() -> Bool {
        return viewModel.exerciseActions.isEmpty || [.name, .rest].contains(currentEditingState)
    }
    
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
        let workoutCarouselViewModel = WorkoutCarouselViewModel(context: persistenceController.container.viewContext)
        let workoutEditViewModel = WorkoutEditTemporaryViewModel(parentViewModel: workoutCarouselViewModel, editingWorkout: workoutCarouselViewModel.workouts[0])
        let exerciseEditViewModel = ExerciseEditTemporaryViewModel(parentViewModel: workoutEditViewModel, editingExercise: workoutEditViewModel.exercises[2])
        let exerciseCoordinator = ExerciseEditCoordinator(viewModel: exerciseEditViewModel)
        
        ExerciseEditView(viewModel: exerciseEditViewModel)
            .environmentObject(exerciseCoordinator)
    }
}
