//
//  WorkoutCollectionListView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 09.04.2024.
//

import SwiftUI

struct WorkoutCollectionWorkoutMoveView: View {
    @EnvironmentObject var coordinator: WorkoutCollectionWorkoutMoveCoordinator
    @ObservedObject var viewModel: WorkoutCollectionWorkoutMoveViewModel
    
    var body: some View {
        
        ZStack {
            WorkoutPlanningModalBackgroundView()
            
            VStack (alignment: .leading, spacing: Constants.Design.spacing){
                HStack {
                    Button(action: {
                        coordinator.discardMove()
                    }) {
                        Text("Cancel")
                            .padding(.vertical, Constants.Design.spacing/2)
                            .padding(.trailing, Constants.Design.spacing/2)
                    }
                }
                .padding(.horizontal, Constants.Design.spacing)
                
                HStack (alignment: .center, spacing: Constants.Design.spacing/2){
                    Image(systemName: "square.and.arrow.down")
                    Text(viewModel.movingWorkout.name)
                        .lineLimit(2)
                }
                .font(.title3)
                .padding(.horizontal, Constants.Design.spacing)
                
                Text("Select a collection")
                    .font(.title2.bold())
                    .padding(.horizontal, Constants.Design.spacing)
                
                ScrollView {
                    LazyVStack (alignment: .leading, spacing: Constants.Design.spacing) {
                        ForEach(viewModel.collections, id: \.id) { collection in
                            Button(action: {
                                coordinator.saveMove(to: collection)
                            }) {
                                Text(collection.name)
                                    .font(.headline)
                            }
                            if collection != viewModel.collections.last {
                                Divider()
                            }
                            ForEach(collection.subCollections) { subCollection in
                                Divider()
                                    .padding(.leading, Constants.Design.spacing)
                                
                                Button(action: {
                                    coordinator.saveMove(to: subCollection)
                                }) {
                                    Text(subCollection.name)
                                        .font(.subheadline)
                                        .padding(.leading, Constants.Design.spacing)
                                }
                            }
                            
                        }
                    }
                }
                .padding(Constants.Design.spacing)
                .materialCardBackgroundModifier()
                .padding(.horizontal, Constants.Design.spacing)
                
            }
        }
        .accentColor(Constants.Design.Colors.textColorHighEmphasis)
        
    }
}

struct WorkoutCollectionEditView_Previews: PreviewProvider {
    
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        
        let collectionsViewModel = WorkoutCollectionViewModel(context: persistenceController.container.viewContext)
        
        let collectionDataManager = CollectionDataManager()
        let firstCollection = collectionDataManager.fetchFirstUserCollection(in: persistenceController.container.viewContext)
        
        let workoutForPreview = collectionDataManager.fetchWorkouts(for: firstCollection!, in: persistenceController.container.viewContext).first
        
        let workoutMoveModel = WorkoutCollectionWorkoutMoveViewModel(parentViewModel: collectionsViewModel, movingWorkout: (workoutForPreview?.toWorkoutCollectionWorkoutRepresentation())!)
        
        let workoutMoveCoordinator = WorkoutCollectionWorkoutMoveCoordinator(viewModel: workoutMoveModel)
        
        WorkoutCollectionWorkoutMoveView(viewModel: workoutMoveModel)
            .environmentObject(workoutMoveCoordinator)
    }
}
