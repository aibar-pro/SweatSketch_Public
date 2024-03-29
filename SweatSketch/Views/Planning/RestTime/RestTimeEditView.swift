//
//  WorkourAdvancedRestTimeEditView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 30.03.2024.
//

import SwiftUI

struct RestTimeEditView: View {
    @EnvironmentObject var coordinator: RestTimeEditCoordinator
    @ObservedObject var viewModel: RestTimeEditTemporaryViewModel
    
    enum EditingState {
        case none
        case rest
    }
    @State private var currentEditingState: EditingState = .none
    
    var body: some View {
        ZStack {
            WorkoutPlanningModalBackgroundView()
            
            GeometryReader { geoReader in
                ScrollViewReader { scrollProxy in
                    VStack (alignment: .leading, spacing: Constants.Design.spacing/2) {
                        HStack {
                            Button(action: {
                                coordinator.discardExerciseEdit()
                            }) {
                                Text("Cancel")
                                    .padding(.vertical, Constants.Design.spacing/2)
                                    .padding(.trailing, Constants.Design.spacing/2)
                            }
    //                        .disabled(currentEditingState == .list)
                            
                            Spacer()
                            
                            Button(action: {
                                coordinator.saveExerciseEdit()
                            }) {
                                Text("Save")
                                    .bold()
                                    .padding(.vertical, Constants.Design.spacing/2)
                                    .padding(.leading, Constants.Design.spacing/2)
                            }
    //                        .disabled(isSaveButtonDisable())
                        }
                        .padding(.horizontal, Constants.Design.spacing)
                    
                        Text(viewModel.editingWorkout?.name ?? Constants.Design.Placeholders.noWorkoutName)
                        .font(.title2.bold())
                        .lineLimit(2)
                        .padding(.horizontal, Constants.Design.spacing)
                        
                        HStack(spacing: 0){
                            Text("Default rest time: ")
                            if let defaultRestTime = viewModel.defaultRestTime?.duration {
                                DurationView(durationInSeconds: Int(defaultRestTime))
                            }
                            
                        }
                        .foregroundSecondaryColorModifier()
                        .padding(.horizontal, Constants.Design.spacing)
//                        .disabled(isRenameDisabled())
                        ScrollView {
                            VStack (alignment: .leading, spacing: Constants.Design.spacing/2) {
                                ForEach(viewModel.exercises, id: \.self) { exercise in
                                    VStack (alignment: .leading, spacing: Constants.Design.spacing) {
                                        if exercise != viewModel.exercises.first {
                                            if viewModel.isEditingRestTime(for: exercise) {
                                                let isEditingBinding = Binding<Bool>(
                                                    get: {
                                                        viewModel.isEditingRestTime(for: exercise)
                                                    },
                                                    set: { isEditing in
                                                        if isEditing {
                                                            viewModel.setEditingRestTime(for: exercise)
                                                            currentEditingState = .rest
                                                            print("binding \(currentEditingState)")
                                                        } else {
                                                            viewModel.clearEditingRestTime()
                                                            currentEditingState = .none
                                                            print("binding \(currentEditingState)")
                                                        }
                                                    }
                                                )
                                                
                                                if let restTimeToEdit = exercise.restTime {
                                                    RestTimeEditPopover(restTimeEntity: restTimeToEdit, showPopover: isEditingBinding) { duration in
                                                        viewModel.updateRestTime(for: exercise, duration: duration)
                                                    }
                                                }
                                            } else {
                                                HStack(alignment: .center, spacing: Constants.Design.spacing) {
                                                    Button(action: {
                                                        viewModel.setEditingRestTime(for: exercise)
                                                        currentEditingState = .rest
                                                        print("button \(currentEditingState)")
                                                    }) {
                                                        HStack (alignment: . center)  {
                                                            Image(systemName: "timer")
                                                            if let exerciseRestTime = exercise.restTime {
                                                                DurationView(durationInSeconds: Int(exerciseRestTime.duration))
                                                            } else {
                                                                Text("Custom rest time")
                                                            }
                                                        }
                                                        .primaryButtonLabelStyleModifier()
                                                    }
                                                    if exercise.restTime != nil {
                                                        Button(action: {
                                                            viewModel.removeRestTime(for: exercise)
                                                        }) {
                                                            Image(systemName: "trash")
                                                        }
                                                    }
                                                }
                                                .frame(width: geoReader.size.width - 2 * Constants.Design.spacing, alignment: .center)
                                            }
                                        }
                                        
                                        Text(exercise.name ?? Constants.Design.Placeholders.noExerciseName)
                                            .padding(Constants.Design.spacing)
                                            .frame(width: geoReader.size.width - 2 * Constants.Design.spacing, alignment: .leading)
                                            .materialCardBackgroundModifier()
                                    }
                                    .id(exercise.objectID)
                                        
                                }
                            }
                        }
                        .onChange(of: viewModel.editingRestTime) { _ in
                            if let latestActionID = viewModel.editingRestTime?.followingExercise?.objectID {
                                withAnimation {
                                    scrollProxy.scrollTo(latestActionID, anchor: .bottom)
                                }
                            }
                        }
                        .padding(.horizontal, Constants.Design.spacing)
                    }
                }
            }
            .accentColor(Constants.Design.Colors.textColorHighEmphasis)
        }
    }
}

struct RestTimeEditView_Preview : PreviewProvider {
    
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        let workoutCarouselViewModel = WorkoutCarouselViewModel(context: persistenceController.container.viewContext)
        let workoutEditViewModel = WorkoutEditTemporaryViewModel(parentViewModel: workoutCarouselViewModel, editingWorkout: workoutCarouselViewModel.workouts[0])
        let restTimeEditViewModel = RestTimeEditTemporaryViewModel(parentViewModel: workoutEditViewModel)
        
        RestTimeEditView(viewModel: restTimeEditViewModel)
            .environmentObject(RestTimeEditCoordinator(viewModel: restTimeEditViewModel))
    }
}
