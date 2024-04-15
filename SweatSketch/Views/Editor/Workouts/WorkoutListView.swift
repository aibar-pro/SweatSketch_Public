//
//  WorkoutListview.swift
//  MyWorkoutPlanner
//
//  Created by aibaranchikov on 18/5/21.
//

import SwiftUI

struct WorkoutListView: View {
    
    @EnvironmentObject var coordinator: WorkoutListCoordinator
    @ObservedObject var viewModel: WorkoutListViewModel
    
    @State private var editMode = EditMode.active
    
    var body: some View {
        GeometryReader { geoReader in
            ZStack{
                WorkoutPlanningMainBackgroundView()
                
                VStack (alignment: .leading) {
                    HStack {
                        Text("Workouts")
                            .font(.title2.bold())
                            .padding(.top, Constants.Design.spacing)
                        .padding(.horizontal, Constants.Design.spacing)
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
                        
                    }
                    
                    List {
                        ForEach(viewModel.workouts, id: \.self) { plan in
                            
                            Text(plan.name ?? Constants.Placeholders.noWorkoutName)
                                .font(.title3)
                                .lineLimit(3)
                                .padding(.horizontal, Constants.Design.spacing/2)
                                .padding(.vertical, Constants.Design.spacing/2)
                                .listRowBackground(
                                    RoundedRectangle(cornerRadius: Constants.Design.cornerRadius, style: .continuous)
                                        .fill(
                                            Color.clear
                                        )
                                        .materialCardBackgroundModifier()
                                        .padding(.all, Constants.Design.spacing/4)
                                )
                            
                        }
                        .onMove(perform: viewModel.moveWorkout)
                        .onDelete(perform: viewModel.deleteWorkout)
                    }
                    .padding(.horizontal, Constants.Design.spacing)
                    .listStyle(.plain)
                    .environment(\.editMode, $editMode)
                    
                    HStack {
                        Button(action: {
                            coordinator.discardlWorkoutListChanges()
                        }) {
                            Text("Cancel")
                                .secondaryButtonLabelStyleModifier()
                        }
                        
                        Button(action: {
                            coordinator.saveWorkoutListChanges()
                        }) {
                            Text("Done")
                                .bold()
                                .primaryButtonLabelStyleModifier()
                        }
                        
                    }
                    .padding(.horizontal, Constants.Design.spacing)
                    .frame(width: geoReader.size.width, alignment: .trailing)
                }
                
            }
            .accentColor(Constants.Design.Colors.textColorHighEmphasis)
        }
    }
}

struct WorkoutListView_Previews: PreviewProvider {
    static var previews: some View {
        
        let persistenceController = PersistenceController.preview
        let workoutViewModel = WorkoutCarouselViewModel(context: persistenceController.container.viewContext)
        let workoutListModel = WorkoutListViewModel(parentViewModel: workoutViewModel, workoutCollection: workoutViewModel.workoutCollection)
        let workoutCoordinator = WorkoutListCoordinator(viewModel: workoutListModel)
        
        WorkoutListView(viewModel: workoutCoordinator.viewModel)
            .environmentObject(workoutCoordinator)
    }
}
