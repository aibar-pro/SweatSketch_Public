//
//  WorkoutCatalogCollectionMoveView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 13.04.2024.
//

import SwiftUI

struct WorkoutCatalogCollectionMoveView: View {
    @EnvironmentObject var coordinator: WorkoutCatalogCollectionMoveCoordinator
    @ObservedObject var viewModel: WorkoutCatalogCollectionMoveViewModel
    
    var body: some View {
        
        ZStack {
            WorkoutPlanningModalBackgroundView()
            
            VStack (alignment: .leading, spacing: Constants.Design.spacing){
                HStack {
                    Button(action: {
                        coordinator.discardMove()
                    }) {
                        Text(Constants.Placeholders.cancelButtonLabel)
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
                            .disabled(collection == viewModel.movingCollection)
                            Divider()
                        }
                        HStack {
                            Spacer()
                            Button(action: {
                                coordinator.saveMove(to: nil)
                            }) {
                                Text(Constants.Placeholders.WorkoutCatalog.moveTopDestinationText)
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
        .customAccentColorModifier(Constants.Design.Colors.textColorHighEmphasis)
    }
}
    
struct WorkoutCatalogCollectionMoveView_Previews: PreviewProvider {
    
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        
        let collectionsViewModel = WorkoutCatalogViewModel(context: persistenceController.container.viewContext)
        
        let collectionDataManager = CollectionDataManager()
        let firstCollection = collectionDataManager.fetchFirstUserCollection(in: persistenceController.container.viewContext)
        
        let collectionMoveModel = WorkoutCatalogCollectionMoveViewModel(parentViewModel: collectionsViewModel, movingCollection: firstCollection!.toWorkoutCollectionRepresentation(includeSubCollections: false, includeWorkouts: false)!)
        
        let collectionMoveModelCoordinator = WorkoutCatalogCollectionMoveCoordinator(viewModel: collectionMoveModel)
        
        WorkoutCatalogCollectionMoveView(viewModel: collectionMoveModel)
            .environmentObject(collectionMoveModelCoordinator)
    }
}
