//
//  WorkoutEditView.swift
//  MyWorkoutPlanner
//
//  Created by aibaranchikov on 24.11.2023.
//

import SwiftUI

struct WorkoutEditView: View {
    
    @EnvironmentObject var coordinator: WorkoutEditCoordinator
    @ObservedObject var viewModel: WorkoutEditTemporaryViewModel
    
    @GestureState var titlePress = false
    @State private var newWorkoutName : String = ""
    
    
    @State private var isEditingName : Bool = false
    @State private var isEditingList : Bool = false
    @State private var isEditingRestPeriod : Bool = false
    
    var body: some View {
        
        let exercises = viewModel.exercises
       
        ZStack {
            GeometryReader { gReader in
                VStack (alignment: .leading, spacing: Constants.Design.spacing/2) {

                    HStack {
                        Button(action: {
                            if isEditingName {
                                newWorkoutName.removeAll()
                                isEditingName = false
                            } else if isEditingList {
                                isEditingList = false
                            } else {
                                coordinator.discardWorkoutEdit()
                            }
                        }) {
                            Text("Cancel")
                                .padding(.vertical, Constants.Design.spacing/2)
                                .padding(.trailing, Constants.Design.spacing/2)
                        }
                        Spacer()
                        Button(action: {
                           viewModel.undo()
                        }) {
                            Image(systemName: "arrow.uturn.backward")
                        }
                        .padding(.vertical, Constants.Design.spacing/2)
                        .padding(.horizontal, Constants.Design.spacing/2)
                        .disabled(!viewModel.canUndo)
                        Button(action: {
                            viewModel.redo()
                        }) {
                            Image(systemName: "arrow.uturn.forward")
                        }
                        .padding(.vertical, Constants.Design.spacing/2)
                        .padding(.horizontal, Constants.Design.spacing/2)
                        .disabled(!viewModel.canRedo)
                        Spacer()
                        Button(action: {
                            if isEditingName {
                                viewModel.renameWorkout(newName: newWorkoutName)
                                newWorkoutName.removeAll()
                                isEditingName = false
                            } else if isEditingList {
                                isEditingList = false
                            } else {
                                coordinator.saveWorkoutEdit()
                            }
                        }) {
                            Text(isEditingName ? "Rename" : "Done")
                                .bold()
                                .padding(.vertical, Constants.Design.spacing/2)
                                .padding(.leading, Constants.Design.spacing/2)
                        }
                        .disabled(newWorkoutName.isEmpty&&isEditingName)
                        
                    }
                    .padding(.horizontal, Constants.Design.spacing)
                    
                    Text(viewModel.editingWorkout?.name ?? Constants.Design.Placeholders.noWorkoutName)
                        .font(.title2.bold())
                        .lineLimit(2)
                        .padding(.horizontal, Constants.Design.spacing)
                        .scaleEffect(titlePress ? 0.95 : 1)
                        .animation(.spring(response: 0.4, dampingFraction: 0.6))
                        .gesture(
                              LongPressGesture(minimumDuration: 0.5)
                                  .updating($titlePress) { currentState, gestureState, transaction in
                                      gestureState = currentState
                                  }
                                  .onEnded { value in
                                      isEditingName = true
                                  }
                          )
                        .disabled(isEditingName || isEditingList || isEditingRestPeriod)
                    
                    ZStack {
                        List {
                            ForEach (exercises, id: \.self) { exercise in
                                HStack (alignment: .top){
                                    ExerciseView(exerciseEntity: exercise)
                                    Spacer()
                                    Button(action: {
                                        print("Edit exercise: \(exercise.name ?? "")")
                                        coordinator.goToEditWorkout(exerciseToEdit: exercise)
                                    }) {
                                        Image(systemName: "ellipsis")
                                            .font(.title3)
                                            .padding(.trailing, Constants.Design.spacing/4)
                                            .padding(.vertical, Constants.Design.spacing/4)
                                    }
                                }
                                .padding(.vertical, Constants.Design.spacing/4)
                                .listRowBackground(
                                    RoundedRectangle(cornerRadius: Constants.Design.cornerRadius, style: .continuous)
                                        .fill(
                                            Color.clear
                                        )
                                        .materialCardBackgroundModifier()
                                        .padding(.all, Constants.Design.spacing/4)
                                )
                            }
                            .onDelete { index in viewModel.deleteWorkoutExercise(at: index) }
                            .onMove(perform: viewModel.reorderWorkoutExercise)
                        }
                        .padding(.horizontal, Constants.Design.spacing/2)
                        .opacity(isEditingName || isEditingRestPeriod ? 0.2 : 1)
                        .disabled(isEditingName || isEditingRestPeriod)
                        .listStyle(.plain)
                        .environment(\.editMode,
                                      .constant(isEditingList ? EditMode.active : EditMode.inactive))
                        .animation(.easeInOut(duration: 0.25))
                        .onChange(of: exercises.count==0, perform: { _ in
                            if isEditingList {
                                isEditingList = false
                            }
                        })
                        
                        VStack {
                            if isEditingName {
                                VStack {
                                    VStack (alignment: .leading) {
                                        Text("Enter new workout name:")
                                            .font(.title3)
                                        
                                        TextField("New name", text: $newWorkoutName)
                                            .padding(.horizontal, Constants.Design.spacing/2)
                                            .padding(.vertical, Constants.Design.spacing)
                                            .background(
                                                RoundedRectangle(cornerRadius: Constants.Design.cornerRadius)
                                                    .stroke(Constants.Design.Colors.backgroundStartColor)
                                            )
                                        
                                    }
                                    .padding(Constants.Design.spacing)
                                }
                                .materialCardBackgroundModifier()
                                .padding(.horizontal, Constants.Design.spacing)
                            }
                            
                            Spacer()
                            
                            if isEditingRestPeriod {
                                RestPeriodPopoverView()
                                    .padding(Constants.Design.spacing)
                                    .materialCardBackgroundModifier()
                            }
                        }
                    }
                    HStack (alignment: .bottom, spacing: Constants.Design.spacing) {
                        Button(action: {
                            isEditingList.toggle()
                        }) {
                            Image(systemName: "arrow.up.arrow.down")
                                .padding(Constants.Design.spacing/2)
                        }
                        .disabled(exercises.isEmpty || isEditingName || isEditingRestPeriod)
                      
                        Button(action: {
                            isEditingRestPeriod.toggle()
                        }) {
                            Image(systemName: "timer")
                                .padding(Constants.Design.spacing/2)
                        }
                        .disabled(isEditingName || isEditingList)
                    
                        Spacer()
                        Button(action: {
                            coordinator.goToAddExercise()
                        }) {
                            Image(systemName: "plus")
                                .font(.title2.bold())
                                .primaryButtonLabelStyleModifier()
                        }
                        .disabled(isEditingName || isEditingList || isEditingRestPeriod)
                    }
                    .padding(.horizontal, Constants.Design.spacing)
                }
                .accentColor(Constants.Design.Colors.textColorHighEmphasis)
            }
        }
    }
}

struct WorkoutEditView_Previews: PreviewProvider {
    static var previews: some View {
        
        let persistenceController = PersistenceController.preview
        let workoutViewModel = WorkoutCarouselViewModel(context: persistenceController.container.viewContext)
        let workoutEditModel = WorkoutEditTemporaryViewModel(parentViewModel: workoutViewModel, editingWorkout: workoutViewModel.workouts[0])
        let workoutEditCoordinator = WorkoutEditCoordinator(viewModel: workoutEditModel)
        
        WorkoutEditView(viewModel: workoutEditCoordinator.viewModel)
            .environmentObject(workoutEditCoordinator)

    }
}
