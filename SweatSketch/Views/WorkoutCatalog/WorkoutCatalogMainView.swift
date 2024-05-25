//
//  WorkoutCatalogMainView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 05.04.2024.
//

import SwiftUI

struct WorkoutCatalogMainView: View {
    @ObservedObject var viewModel: WorkoutCatalogViewModel
    @EnvironmentObject var coordinator: WorkoutCatalogCoordinator
    
    enum EditingState {
        case none
        case newCollection
        case renameCollection
        case moveWorkout
    }
    @State private var currentEditingState: EditingState = .none
    
    @State private var searchText: String = ""
    
    @State private var isLoggedIn: Bool = false
    
    var body: some View {
        VStack (alignment: .leading, spacing: Constants.Design.spacing){
            HStack (alignment: .center){
                Text(Constants.Placeholders.WorkoutCatalog.title)
                    .font(.title2.bold())
                    .lineLimit(2)
                    
                Spacer()
                
                if isLoggedIn {
                    Text(Constants.Placeholders.WorkoutCatalog.userLoggedInLabel)
                } else {
                    UserProfileButtonView(onClick: coordinator.goToProfile)
                }
            }
            .padding(.top, Constants.Design.spacing/4)
            .padding(.horizontal, Constants.Design.spacing/2)
            
            VStack {
                ZStack {
                    GeometryReader { listGeo in
                        ScrollView {
                            LazyVStack (alignment: .leading, spacing: Constants.Design.spacing/2){
                                ForEach(viewModel.collections, id: \.id) { collection in
                                    Section(header:
                                        HStack (alignment: .center) {
                                            Button(action: {
                                                coordinator.goToWorkoutCollection(collectionUUID: collection.id)
                                            }) {
                                                
                                                Text(collection.name)
                                                    .font(.headline)
                                                    .lineLimit(2)
                                                    .padding(.vertical, Constants.Design.spacing/4)
                                                    .padding(.trailing, Constants.Design.spacing/2)
                                            }
                                            
                                            Spacer()
                                            
                                            Menu {
                                                Button(Constants.Placeholders.WorkoutCatalog.renameCollectionButtonLabel) {
                           
                                               }
                                                
                                                Button(Constants.Placeholders.WorkoutCatalog.moveCollectionButtonLabel) {
                                                    coordinator.goToMoveCollection(movingCollection: collection)
                                                }
                           
                                               Button(Constants.Placeholders.WorkoutCatalog.mergeCollectionButtonLabel) {
                                                   coordinator.goToMergeCollection(sourceCollection: collection)
                                               }
                                           } label: {
                                               Image(systemName: "ellipsis")
                                                   .padding(.leading, Constants.Design.spacing/2)
                                                   .padding(.vertical, Constants.Design.spacing/4)
                                           }
                                        }
                                    ) {
                                        LazyVStack (alignment: .leading, spacing: Constants.Design.spacing/2) {
                                            ForEach(collection.workouts, id: \.id) { workout in
                                                WorkoutCatalogWorkoutRowView(workoutRepresentation: workout, onMoveRequested: { workout in
                                                    print(workout.name)
                                                    coordinator.goToMoveWorkout(movingWorkout: workout)
                                                })
                                                .padding(Constants.Design.spacing/2)
                                                .materialCardBackgroundModifier()
                                            }
                                            ForEach(collection.subCollections, id: \.id) { subCollection in
                                                Section(header:
                                                    HStack (alignment: .center) {
                                                        Button(action: {
                                                            coordinator.goToWorkoutCollection(collectionUUID: subCollection.id)
                                                        }) {
                                                            Text(subCollection.name)
                                                                .font(.subheadline)
                                                                .lineLimit(1)
                                                                .padding(.vertical, Constants.Design.spacing/4)
                                                                .padding(.trailing, Constants.Design.spacing/2)
                                                        }
                                                    
                                                        Spacer()
                                                        
                                                        Menu {
                                                            Button(Constants.Placeholders.WorkoutCatalog.renameCollectionButtonLabel) {
                                       
                                                            }
                                       
                                                            Button(Constants.Placeholders.WorkoutCatalog.moveCollectionButtonLabel) {
                                                                coordinator.goToMoveCollection(movingCollection: subCollection)
                                                            }
                                       
                                                           Button(Constants.Placeholders.WorkoutCatalog.mergeCollectionButtonLabel) {
                                                               coordinator.goToMergeCollection(sourceCollection: subCollection)
                                                           }
                                                       } label: {
                                                           Image(systemName: "ellipsis")
                                                               .padding(.leading, Constants.Design.spacing/2)
                                                               .padding(.vertical, Constants.Design.spacing/4)
                                                       }
                                                    }
                                                ) {
                                                    ForEach(subCollection.workouts, id: \.id) { workout in
                                                        WorkoutCatalogWorkoutRowView(workoutRepresentation: workout, onMoveRequested: { workout in
                                                            print(workout.name)
                                                            coordinator.goToMoveWorkout(movingWorkout: workout)
                                                        })
                                                        .padding(Constants.Design.spacing/2)
                                                        .materialCardBackgroundModifier()
                                                    }
                                                    .padding(.leading, Constants.Design.spacing/2)
                                                }
                                                .padding(.leading, Constants.Design.spacing/2)
                                            }
                                        }
                                        .padding(.bottom, Constants.Design.spacing)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, Constants.Design.spacing)
                        .opacity(currentEditingState != .none ? 0.2 : 1)
                        .disabled(currentEditingState != .none)
                    }
                    VStack{
                        if currentEditingState == .newCollection {
                            TextFieldPopoverView(
                                popoverTitle: Constants.Placeholders.WorkoutCatalog.addCollectionPopupTitle,
                                textFieldLabel: Constants.Placeholders.WorkoutCatalog.addCollectionPopupText,
                                buttonLabel: Constants.Placeholders.WorkoutCatalog.addCollectionPopupButtonLabel,
                                onDone: { newName in
                                    viewModel.addCollection(with: newName)
                                    currentEditingState = .none
                                }, onDiscard: {
                                    currentEditingState = .none
                            })
                        }
                        Spacer()
                    }
                }
                
                Button(action: {
                    currentEditingState = .newCollection
                }) {
                    Image(systemName: "plus")
                        .padding(.vertical, Constants.Design.spacing/2)
                        .padding(.horizontal, Constants.Design.spacing/2)
                }
            }
            
        }
        .accentColor(Constants.Design.Colors.textColorHighEmphasis)
        
    }
    
    private func getWorkoutCount(for collection: WorkoutCatalogCollectionViewRepresentation) -> Int {
        if collection.workouts.isEmpty {
            return 0
        } else {
            return collection.workouts.count
        }
    }
    
}

struct WorkoutCollectionMainView_Previews: PreviewProvider {
    
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        
        let appCoordinator = ApplicationCoordinator(dataContext: persistenceController.container.viewContext)
        let applicationEvent = appCoordinator.applicationEvent
        
        let collectionCoordinator = WorkoutCatalogCoordinator(dataContext: persistenceController.container.viewContext, applicationEvent: applicationEvent)
        
        WorkoutCatalogMainView(viewModel: collectionCoordinator.viewModel)
            .environmentObject(collectionCoordinator)
    }
}
