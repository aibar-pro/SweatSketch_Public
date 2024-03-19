//
//  WorkoutListview.swift
//  MyWorkoutPlanner
//
//  Created by aibaranchikov on 18/5/21.
//

import SwiftUI

struct WorkoutListView: View {
    
    @EnvironmentObject var coordinator: WorkoutListCoordinator
    
    @State private var editMode = EditMode.active
    
    var body: some View {
        GeometryReader { geoReader in
            ZStack{
                BackgroundGradientView()
                
                VStack (alignment: .leading) {
                    Text("Workouts")
                        .font(.title2.bold())
                        .padding(.top, Constants.Design.spacing)
                        .padding(.horizontal, Constants.Design.spacing)
                        
                    List {
                        let viewModel = coordinator.viewModel
                        
                        ForEach(viewModel.workouts, id: \.self) { plan in
                            Text(plan.name ?? "n/a")
                                .font(.title3)
                                .lineLimit(3)
                                .listRowBackground(
                                    RoundedRectangle(cornerRadius: Constants.Design.cornerRadius, style: .continuous)
                                        .fill(
                                            Color.clear
                                        )
                                        .modifier(CardBackgroundModifier(cornerRadius: Constants.Design.cornerRadius))
                                        .padding(.all, 5)
                                )
                            
                        }
                        
                        .onDelete(perform: viewModel.deleteWorkout)
                        .onMove(perform: viewModel.moveWorkout)
                        
                    }
                    .padding(.horizontal, Constants.Design.spacing)
                    .listStyle(.plain)
                    
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
                                .primaryButtonLabelStyleModifier()
                        }
                        
                    }
                    .padding(.horizontal, Constants.Design.spacing)
                    .frame(width: geoReader.size.width, alignment: .trailing)
                }
                
                .environment(\.editMode, $editMode)
            }
            .accentColor(.primary)
        }
    }
}

import CoreData

struct WorkoutListView_Previews: PreviewProvider {
    static var previews: some View {
        
        let persistenceController = PersistenceController.preview
        let workoutViewModel = WorkoutCarouselViewModel(context: persistenceController.container.viewContext)
        let workoutListModel = WorkoutListTemporaryViewModel(parentViewModel: workoutViewModel)
        
        WorkoutListView()
            .environmentObject(WorkoutListCoordinator(viewModel: workoutListModel))
    }
}
