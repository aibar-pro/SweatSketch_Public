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
    
    @State private var currentEditingState: EditingState = .none
    
    @State private var searchText: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.Design.spacing) {
            headerView
            
            VStack(alignment: .center, spacing: Constants.Design.spacing) {
                ZStack {
                    ScrollView(showsIndicators: false) {
                        LazyVStack(alignment: .leading, spacing: Constants.Design.spacing){
                            ForEach(viewModel.collections, id: \.id) { collection in
                                collectionSection(collection)
                            }
                        }
                        .customForegroundColorModifier(Constants.Design.Colors.textColorHighEmphasis)
                        .padding(Constants.Design.spacing)
                        .materialCardBackgroundModifier()
                    }
                    .opacity(currentEditingState != .none ? 0.2 : 1)
                    .disabled(currentEditingState != .none)
                    
                    //TODO: Move to bottom sheet
                    VStack{
                        if currentEditingState == .newCollection {
                            addCollectionPopoverView
                        }
                        Spacer()
                    }
                    
                    footerView
                }
            }
        }
        .padding(Constants.Design.spacing)
    }
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: Constants.Design.spacing) {
            HStack(alignment: .center) {
                Text("catalog.title")
                    .fullWidthText(.title, isBold: true)
                    .lineLimit(2)
                
                Spacer(minLength: 0)
                
                UserProfileButtonView(
                    isLoggedIn: $viewModel.isLoggedIn,
                    onTap: coordinator.goToProfile
                )
                .onAppear {
                    print("Button appear: \(viewModel.isLoggedIn)")
                }
            }
        }
    }
    
    private func collectionSection(_ collection: CollectionRepresentation) -> some View {
        Section(
            content: {
                Group {
                    if collection.subCollections.isEmpty, collection.workouts.isEmpty {
                        Text("catalog.empty.collection")
                            .fullWidthText()
                    } else {
                        VStack(alignment: .leading, spacing: Constants.Design.spacing) {
                            if !collection.workouts.isEmpty {
                                collectionWorkouts(collection)
                                    .padding(.bottom, Constants.Design.spacing)
                            }
                            
                            if !collection.subCollections.isEmpty {
                                ForEach(collection.subCollections, id: \.id) { sub in
                                    subCollectionSection(sub)
                                }
                            }
                        }
                    }
                }
                .padding(.leading, Constants.Design.spacing)
                .padding(.bottom, Constants.Design.spacing)
            },
            header: {
                collectionHeader(collection, isTopLevel: true)
            }
        )
    }
    
    private func subCollectionSection(_ collection: CollectionRepresentation) -> some View {
        Section(
            content: {
                Group {
                    if collection.workouts.isEmpty {
                        Text("catalog.empty.collection")
                            .fullWidthText()
                    } else {
                        VStack(alignment: .leading, spacing: Constants.Design.spacing) {
                            collectionWorkouts(collection)
                        }
                    }
                }
                .padding(.leading, Constants.Design.spacing)
                .padding(.bottom, Constants.Design.spacing)
            },
            header: {
                collectionHeader(collection)
            }
        )
    }
    
    private func collectionHeader(_ collection: CollectionRepresentation, isTopLevel: Bool = false) -> some View {
        HStack(alignment: .top, spacing: Constants.Design.spacing) {
            Button(action: {
                coordinator.goToWorkoutCollection(collectionUUID: collection.id)
            }) {
                Text(collection.name)
                    .fullWidthText(
                        isTopLevel ? .title2 : .title3,
                        isBold: true
                    )
                    .lineLimit(2)
            }
            
            Spacer(minLength: 0)
            
            MenuButton(
                style: .inline,
                content: {
                    Button("catalog.collection.menu.rename") {
                        
                    }
                    Button("catalog.collection.menu.move") {
                        coordinator.goToMoveCollection(movingCollection: collection)
                    }
                    Button("catalog.collection.menu.merge") {
                        coordinator.goToMergeCollection(sourceCollection: collection)
                    }
                }
            )
        }
    }
    
    private func collectionWorkouts(_ collection: CollectionRepresentation) -> some View {
        VStack(alignment: .leading, spacing: Constants.Design.spacing) {
            ForEach(collection.workouts, id: \.id) { workout in
                WorkoutCatalogWorkoutRowView(
                    workout: workout,
                    isLoggedIn: $viewModel.isLoggedIn,
                    onMoveRequested: {
                        coordinator.goToMoveWorkout(movingWorkout: $0)
                    },
                    onShareRequested: {
                        coordinator.goToShareWorkout(movingWorkout: $0)
                    }
                )
            }
        }
    }
    
    private var addCollectionPopoverView: some View {
        TextFieldPopoverView(
            popoverTitle: Constants.Placeholders.WorkoutCatalog.addCollectionPopupTitle,
            textFieldLabel: Constants.Placeholders.WorkoutCatalog.addCollectionPopupText,
            buttonLabel: Constants.Placeholders.WorkoutCatalog.addCollectionPopupButtonLabel,
            onDone: { newName in
                viewModel.addCollection(with: newName)
                currentEditingState = .none
            }, onDiscard: {
                currentEditingState = .none
            }
        )
    }
    
    private var footerView: some View {
        HStack(alignment: .center, spacing: Constants.Design.spacing) {
            IconButton(
                systemImage: "plus",
                style: .secondary,
                action: {
                    currentEditingState = .newCollection
                }
            )
            
            RectangleButton(
                content: {
                    HStack(alignment: .center, spacing: Constants.Design.spacing / 2) {
                        Image(systemName: "square.and.arrow.down")
                        Text("catalog.import.workout")
                    }
                },
                style: .secondary,
                action: {
                    
                }
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
    }
    
    private func getWorkoutCount(for collection: CollectionRepresentation) -> Int {
        if collection.workouts.isEmpty {
            return 0
        } else {
            return collection.workouts.count
        }
    }
    
    enum EditingState {
        case none
        case newCollection
        case renameCollection
        case moveWorkout
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
