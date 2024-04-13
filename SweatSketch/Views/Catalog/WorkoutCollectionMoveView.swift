//
//  WorkoutCollectionMoveView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 13.04.2024.
//

import SwiftUI

struct WorkoutCollectionMoveView: View {
    @EnvironmentObject var coordinator: WorkoutCollectionMoveCoordinator
    @ObservedObject var viewModel: WorkoutCollectionMoveViewModel
    
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
                    Text(viewModel.movingCollection.name)
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
                            .disabled(collection == viewModel.movingCollection)
                            Divider()
                        }
                        HStack {
                            Spacer()
                            Button(action: {
                                coordinator.saveMove(to: nil)
                            }) {
                                Text("To the top")
                                    .font(.headline)
                            }
                            Spacer()
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
    
struct WorkoutCollectionMoveView_Previews: PreviewProvider {
    
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        
        let collectionsViewModel = WorkoutCollectionViewModel(context: persistenceController.container.viewContext)
        
        let collectionDataManager = CollectionDataManager()
        let firstCollection = collectionDataManager.fetchFirstUserCollection(in: persistenceController.container.viewContext)
        
        let collectionMoveModel = WorkoutCollectionMoveViewModel(parentViewModel: collectionsViewModel, movingCollection: firstCollection!.toWorkoutCollectionRepresentation(includeSubCollections: false, includeWorkouts: false)!)
        
        let collectionMoveModelCoordinator = WorkoutCollectionMoveCoordinator(viewModel: collectionMoveModel)
        
        WorkoutCollectionMoveView(viewModel: collectionMoveModel)
            .environmentObject(collectionMoveModelCoordinator)
    }
}
