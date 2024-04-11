//
//  WorkoutCollectionMainView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 05.04.2024.
//

import SwiftUI

struct WorkoutCollectionMainView: View {
    @ObservedObject var viewModel: WorkoutCollectionViewModel
    @EnvironmentObject var coordinator: WorkoutCollectionCoordinator
    
    var body: some View {
        VStack (alignment: .leading, spacing: Constants.Design.spacing){
            HStack {
                Text("Workout Catalog")
                    .font(.title2.bold())
                    .lineLimit(2)
                    
                Spacer()
                
                Button(action: {
                    coordinator.goToAddCollection()
                }) {
                    Image(systemName: "plus")
                }
            }
            .padding(.horizontal, Constants.Design.spacing)
            
            ScrollView {
                LazyVStack (alignment: .leading, spacing: Constants.Design.spacing/2){
                    ForEach(viewModel.collections, id: \.id) { collection in
                        Section(header:
                            HStack {
                                Text(collection.name)
                                .font(.headline)
                                    .lineLimit(2)
//                                Spacer()
//                                Button(action: {
//                                    coordinator.goToWorkoutCollection(collectionUUID: collection.id)
//                                }) {
//                                    Image(systemName: "ellipsis")
//                                }
                            }
                            .padding(.vertical, Constants.Design.spacing/2)
                        ) {
                            if !collection.workouts.isEmpty {
                                HStack(alignment: .center) {
                                    VStack (alignment: .leading, spacing: Constants.Design.spacing/2) {
                                        ForEach(collection.workouts, id: \.self) { workout in
                                            Text(workout.name ?? Constants.Placeholders.noWorkoutName)
                                                .padding(.leading, Constants.Design.spacing)
                                        }
                                    }
                                    Spacer()
                                    Button(action: {
                                        coordinator.goToWorkoutCollection(collectionUUID: collection.id)
                                    }) {
                                        Image(systemName: "chevron.forward")
                                    }
                                }
                            }
                            ForEach(collection.subCollections, id: \.id) { subCollection in
                                DisclosureGroup(
                                    content: {
                                        HStack(alignment: .center) {
                                            VStack (alignment: .leading, spacing: Constants.Design.spacing/2) {
                                                ForEach(subCollection.workouts, id: \.self) { workout in
                                                    Text(workout.name ?? Constants.Placeholders.noWorkoutName)
                                                        .padding(.leading, Constants.Design.spacing)
                                                }
                                            }
                                            Spacer()
                                            Button(action: {
                                                coordinator.goToWorkoutCollection(collectionUUID: subCollection.id)
                                            }) {
                                                Image(systemName: "chevron.forward")
                                            }
                                        }
                                        .padding(.vertical, Constants.Design.spacing/2)
                                    },
                                    label: {
                                        Text(subCollection.name)
                                            .font(.subheadline)
                                            .padding(.bottom, Constants.Design.spacing/2)
                                    }
                                )
                                .padding(.leading, Constants.Design.spacing)
    
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, Constants.Design.spacing)
           
        }
        .accentColor(Constants.Design.Colors.textColorMediumEmphasis)
        
    }
}

struct WorkoutCollectionMainView_Previews: PreviewProvider {
    
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        
        let appCoordinator = ApplicationCoordinator(dataContext: persistenceController.container.viewContext)
        let workoutEvent = appCoordinator.workoutEvent
        
        let collectionCoordinator = WorkoutCollectionCoordinator(dataContext: persistenceController.container.viewContext, workoutEvent: workoutEvent)
        
        WorkoutCollectionMainView(viewModel: collectionCoordinator.viewModel)
            .environmentObject(collectionCoordinator)
    }
}
