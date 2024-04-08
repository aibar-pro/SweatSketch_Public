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
        VStack {
            Button("To carousel") {
                coordinator.goToWorkoutCollection()
            }
            .padding(50)
                
            List {
                ForEach(viewModel.collections, id: \.id) { collection in
                    Section(header: Text(collection.name)) {
                        ForEach(collection.subCollections, id: \.id) { subCollection in
                            DisclosureGroup(subCollection.name) {
                                ForEach(subCollection.workouts, id: \.self) { workout in
                                    Text(workout.name ?? "AAAA")
                                }
                            }
                        }
                        
                        ForEach(collection.workouts, id: \.self) { workout in
                            Text(workout.name ?? "AAAA")
                        }
                    }
                }
            
            }
        }
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
