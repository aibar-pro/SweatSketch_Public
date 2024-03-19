//
//  WorkoutEditView.swift
//  MyWorkoutPlanner
//
//  Created by aibaranchikov on 24.11.2023.
//

import SwiftUI

struct WorkoutEditView: View {
    
    @EnvironmentObject var coordinator: WorkoutEditCoordinator
    
    @GestureState var titlePress = false
    @State private var newWorkoutName : String = ""
    
    @State private var isEditingName : Bool = false
    @State private var isEditingList : Bool = false
    
    var body: some View {
        
        let viewModel = coordinator.viewModel
        let exercises = viewModel.exercises
       
        ZStack {
            BackgroundGradientView()
            
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
                    
                    Text(viewModel.editingWorkout?.name ?? "Unnamed")
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
                        .disabled(isEditingName || isEditingList)
                        
                    if !isEditingName {
                        HStack {
                            List {
                                ForEach (exercises) { exercise in
                                    HStack (alignment: .top){
                                        ExerciseView(exercise: exercise)
                                        Spacer()
                                        if !isEditingName, !isEditingList {
                                            Button(action: {
                                                print("Edit exercise: \(exercise.name ?? "")")
                                            }) {
                                                Image(systemName: "ellipsis")
                                                    .font(.title3)
                                            }
                                        } else {
                                            EmptyView()
                                        }
                                    }
                                    .listRowBackground(Color.clear)
                                }
                                .onDelete { index in viewModel.deleteExercise(at: index) }
                                .onMove(perform: viewModel.reorderExercise)
                            }
                            .listStyle(.plain)
                            .environment(\.editMode,
                                          .constant(isEditingList ? EditMode.active : EditMode.inactive))
                            .animation(.easeInOut(duration: 0.25))
                            .onChange(of: exercises.count==0, perform: { _ in
                                if isEditingList {
                                    isEditingList = false
                                }
                            })
                        }
                    } else {
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
                        .modifier(CardBackgroundModifier(cornerRadius: Constants.Design.cornerRadius))
                        .padding(.horizontal, Constants.Design.spacing)
                    }
                    
                    if !isEditingList && !isEditingName {
                        HStack {
                            Button(action: {
                                isEditingList.toggle()
                            }) {
                                Image(systemName: "arrow.up.arrow.down")
                                    .padding(Constants.Design.spacing/2)
                            }
                            .disabled(exercises.isEmpty)
                            
                            Spacer()
                            Button(action: {
                                
                            }) {
                                Image(systemName: "plus")
                                    .font(.title2.bold())
                                    .primaryButtonLabelStyleModifier()
                            }
                        }
                        .padding(.horizontal, Constants.Design.spacing)
                    } else {
                        /*@START_MENU_TOKEN@*/EmptyView()/*@END_MENU_TOKEN@*/
                    }
                }
                .accentColor(.primary)
            }
        }
    }
}

import CoreData

struct WorkoutEditView_Previews: PreviewProvider {
    static var previews: some View {
        
        let persistenceController = PersistenceController.preview
        let workoutViewModel = WorkoutCarouselViewModel(context: persistenceController.container.viewContext)
        let workoutEditModel = WorkoutEditTemporaryViewModel(parentViewModel: workoutViewModel, editingWorkout: workoutViewModel.workouts[0])
        
        WorkoutEditView()
            .environmentObject(WorkoutEditCoordinator(viewModel: workoutEditModel))

    }
}
