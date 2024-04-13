//
//  WorkoutCollectionMergeView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 13.04.2024.
//

import SwiftUI

struct WorkoutCollectionMergeView: View {
    @EnvironmentObject var coordinator: WorkoutCollectionMergeCoordinator
    @ObservedObject var viewModel: WorkoutCollectionMergeViewModel
    
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
                    Image(systemName: "arrow.triangle.merge")
                        .rotationEffect(Angle(degrees: 180))
                    Text(viewModel.sourceCollection.name)
                        .lineLimit(2)
                }
                .font(.title3)
                .padding(.horizontal, Constants.Design.spacing)
                
                Text("Select a collection to merge")
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
                            .disabled(collection == viewModel.sourceCollection)
                            
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
                                .disabled(subCollection == viewModel.sourceCollection)
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

struct WorkoutCollectionMergeView_Previews: PreviewProvider {
    
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        
        let collectionsViewModel = WorkoutCollectionViewModel(context: persistenceController.container.viewContext)
        
        let collectionDataManager = CollectionDataManager()
        let firstCollection = collectionDataManager.fetchFirstUserCollection(in: persistenceController.container.viewContext)
        
        let workoutMergeModel = WorkoutCollectionMergeViewModel(parentViewModel: collectionsViewModel, sourceCollection: firstCollection!.toWorkoutCollectionRepresentation()!)
        
        let workoutMergeCoordinator = WorkoutCollectionMergeCoordinator(viewModel: workoutMergeModel)
        
        WorkoutCollectionMergeView(viewModel: workoutMergeModel)
            .environmentObject(workoutMergeCoordinator)
    }
}
