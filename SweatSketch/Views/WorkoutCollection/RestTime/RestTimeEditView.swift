//
//  WorkourAdvancedRestTimeEditView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 30.03.2024.
//

import SwiftUI

struct RestTimeEditView: View {
    @EnvironmentObject var coordinator: RestTimeEditCoordinator
    @ObservedObject var viewModel: RestTimeEditViewModel
    
    enum EditingState {
        case none
        case rest
    }
    @State private var currentEditingState: EditingState = .none
    
    var body: some View {
        ZStack {
            WorkoutPlanningModalBackgroundView()
            
//            GeometryReader { geoReader in
//                ScrollViewReader { scrollProxy in
//                    VStack (alignment: .leading, spacing: Constants.Design.spacing/2) {
//                        HStack {
//                            Button(action: {
//                                coordinator.discardRestTimeEdit()
//                            }) {
//                                Text("app.button.cancel.label")
//                                    .padding(.vertical, Constants.Design.spacing/2)
//                                    .padding(.trailing, Constants.Design.spacing/2)
//                            }
//                            .disabled(currentEditingState != .none)
//                            
//                            Spacer()
//                            
//                            Button(action: {
//                                coordinator.saveRestTimeEdit()
//                            }) {
//                                Text("app.button.save.label")
//                                    .bold()
//                                    .padding(.vertical, Constants.Design.spacing/2)
//                                    .padding(.leading, Constants.Design.spacing/2)
//                            }
//                            .disabled(currentEditingState != .none)
//                        }
//                        .padding(.horizontal, Constants.Design.spacing)
//                    
//                        Text(viewModel.editingWorkout.name ?? Constants.Placeholders.noWorkoutName)
//                        .font(.title2.bold())
//                        .lineLimit(2)
//                        .padding(.horizontal, Constants.Design.spacing)
//                        
//                        HStack(spacing: Constants.Design.spacing/2){
//                            Text(Constants.Placeholders.WorkoutCollection.defaultRestTimeLabel)
//                            if let defaultRestTime = viewModel.defaultRestTime?.duration {
//                                DurationView(durationInSeconds: Int(defaultRestTime))
//                            }
//                            
//                        }
//                        .adaptiveForegroundStyle(Constants.Design.Colors.textMediumEmphasis)
//                        .padding(.horizontal, Constants.Design.spacing)
//
//                        ScrollView {
//                            VStack (alignment: .leading, spacing: Constants.Design.spacing/2) {
//                                ForEach(viewModel.exercises, id: \.self) { exercise in
//                                    VStack (alignment: .leading, spacing: Constants.Design.spacing) {
//                                        if exercise != viewModel.exercises.first {
//                                            if let exerciseRestTime = exercise.restTime?.duration, viewModel.isEditingRestTime(for: exercise) {
//                                                RestTimeEditPopover(duration: Int(exerciseRestTime), onDurationChange: { duration in
//                                                    viewModel.updateRestTime(for: exercise, duration: duration)
//                                                    viewModel.clearEditingRestTime()
//                                                    currentEditingState = .none
//                                                }, onDiscard: {
//                                                    viewModel.discardRestTime(for: exercise)
//                                                    viewModel.clearEditingRestTime()
//                                                    currentEditingState = .none
//                                                })
//                                            } else {
//                                                HStack(alignment: .center, spacing: Constants.Design.spacing/2) {
//                                                    Button(action: {
//                                                        viewModel.setEditingRestTime(for: exercise)
//                                                        currentEditingState = .rest
//                                                    }) {
//                                                        HStack (alignment: . center)  {
//                                                            Image(systemName: "timer")
//                                                            if let exerciseRestTime = exercise.restTime {
//                                                                DurationView(durationInSeconds: Int(exerciseRestTime.duration))
//                                                            } else {
//                                                                Text(Constants.Placeholders.WorkoutCollection.customRestTimeAddButtonLabel)
//                                                            }
//                                                        }
//                                                        .primaryButtonLabelStyleModifier()
//                                                    }
//                                                    if exercise.restTime != nil {
//                                                        Button(action: {
//                                                            viewModel.deleteRestTime(for: exercise)
//                                                        }) {
//                                                            Image(systemName: "trash")
//                                                                .secondaryButtonLabelStyleModifier()
//                                                        }
//                                                    }
//                                                }
//                                                .frame(width: geoReader.size.width - 2 * Constants.Design.spacing, alignment: .center)
//                                            }
//                                        }
//                                        
//                                        Text(exercise.name ?? Constants.Placeholders.noExerciseName)
//                                            .padding(Constants.Design.spacing)
//                                            .frame(width: geoReader.size.width - 2 * Constants.Design.spacing, alignment: .leading)
//                                            .cardBackground()
//                                    }
//                                    .id(exercise.objectID)
//                                        
//                                }
//                            }
//                        }
//                        .onChange(of: viewModel.editingRestTime) { _ in
//                            if let latestActionID = viewModel.editingRestTime?.followingExercise?.objectID {
//                                withAnimation {
//                                    scrollProxy.scrollTo(latestActionID, anchor: .bottom)
//                                }
//                            }
//                        }
//                        .padding(.horizontal, Constants.Design.spacing)
//                    }
//                }
//            }
            .adaptiveTint(Constants.Design.Colors.elementFgHighEmphasis)
        }
    }
}

struct RestTimeEditView_Preview : PreviewProvider {
    
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        
        let collectionDataManager = CollectionDataManager()
        let firstCollection = collectionDataManager.fetchFirstUserCollection(in: persistenceController.container.viewContext)!
        
        let workoutCarouselViewModel = WorkoutCollectionViewModel(context: persistenceController.container.viewContext, collectionUUID: firstCollection.uuid)
        
        let workoutForPreview = collectionDataManager.fetchWorkouts(for: firstCollection, in: workoutCarouselViewModel.context).first!
        let workoutEditModel = WorkoutEditorModel(parent: workoutCarouselViewModel, editingWorkoutUUID: workoutForPreview.uuid)!
        
        
        let restTimeEditViewModel = RestTimeEditViewModel(parentViewModel: workoutEditModel)!
        
        RestTimeEditView(viewModel: restTimeEditViewModel)
            .environmentObject(RestTimeEditCoordinator(viewModel: restTimeEditViewModel))
    }
}
