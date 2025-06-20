//
//  WorkoutCatalogWorkoutMoveView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 09.04.2024.
//

import SwiftUI

struct WorkoutCatalogWorkoutMoveView: View {
    @EnvironmentObject var coordinator: WorkoutCatalogWorkoutMoveCoordinator
    @ObservedObject var viewModel: WorkoutCatalogWorkoutMoveViewModel
    
    var body: some View {
        
        ZStack {
            WorkoutPlanningModalBackgroundView()
            
            VStack (alignment: .leading, spacing: Constants.Design.spacing){
                HStack {
                    Button(action: {
                        coordinator.discardMove()
                    }) {
                        Text("app.button.cancel.label")
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
                
                Text(Constants.Placeholders.WorkoutCatalog.moveDestinationText)
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
        .customAccentColorModifier(Constants.Design.Colors.textColorHighEmphasis)
        
    }
}

struct WorkoutCatalogWorkoutMoveView_Previews: PreviewProvider {
    
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        
        let collectionsViewModel = WorkoutCatalogViewModel(context: persistenceController.container.viewContext)
        
        let collectionDataManager = CollectionDataManager()
        let firstCollection = collectionDataManager.fetchFirstUserCollection(in: persistenceController.container.viewContext)
        
        let workoutForPreview = collectionDataManager.fetchWorkouts(for: firstCollection!, in: persistenceController.container.viewContext).first
        
        let workoutMoveModel = WorkoutCatalogWorkoutMoveViewModel(parentViewModel: collectionsViewModel, movingWorkout: (workoutForPreview?.toWorkoutCollectionWorkoutRepresentation())!)
        
        let workoutMoveCoordinator = WorkoutCatalogWorkoutMoveCoordinator(viewModel: workoutMoveModel)
        
        WorkoutCatalogWorkoutMoveView(viewModel: workoutMoveModel)
            .environmentObject(workoutMoveCoordinator)
    }
}
