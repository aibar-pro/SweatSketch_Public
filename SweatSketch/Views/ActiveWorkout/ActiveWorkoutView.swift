//
//  ActiveWorkoutView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 02.04.2024.
//

import SwiftUI

struct ActiveWorkoutView: View {
    @EnvironmentObject var coordinator: ActiveWorkoutCoordinator
    @ObservedObject var viewModel: ActiveWorkoutViewModel
    
    @State var yOffset : CGFloat = 0
    
    var body: some View {
        
        GeometryReader { gReader in
            VStack (alignment: .center, spacing: Constants.Design.spacing) {
                
                HStack{
                    Text(viewModel.activeWorkout.title)
                        .fullWidthText(.title2, weight: .semibold)
                        .lineLimit(2)
                    
                    Spacer()
                    
                    IconButton(
                        systemImage: "flag.checkered.2.crossed",
                        style: .secondary,
                        action: {
                            coordinator.goToWorkoutSummary()
                        }
                    )
                }
                .padding(.horizontal, Constants.Design.spacing)
                
                ScrollViewReader { scrollProxy in
                    ScrollView {
                        VStack (alignment: .center, spacing: Constants.Design.spacing) {
                            ForEach(viewModel.items, id: \.id) { item in
                                if viewModel.isCurrentItem(item: item) {
                                    ActiveWorkoutItemView(
                                        workoutItem: item,
                                        itemProgress: $viewModel.currentProgress,
                                        nextRequested: {
                                            if !viewModel.isLastAction {
                                                viewModel.nextActiveWorkoutItem()
                                            } else {
                                                coordinator.goToWorkoutSummary()
                                            }
                                        },
                                        previousRequested: viewModel.previousActiveWorkoutItem
                                    )
                                    .id(item.id)
                                    .padding(Constants.Design.spacing)
                                    .materialBackground()
                                    .lightShadow()
                                    .padding(.horizontal, Constants.Design.spacing)
                                } else {
                                    Text(item.title)
                                        .font(.subheadline)
                                        .lineLimit(3)
                                        .multilineTextAlignment(.center)
                                        .padding(Constants.Design.spacing)
                                        .opacity(0.4)
                                        .id(item.id)
                                }
                                
                            }
                        }
                    }
                    .onChange(of: viewModel.currentItem) { _ in
                        if let activeItemID = viewModel.currentItem?.id {
                            withAnimation {
                                scrollProxy.scrollTo(activeItemID, anchor: .center)
                            }
                        }
                    }
                    .onAppear(perform: {
                        if let activeItemID = viewModel.currentItem?.id {
                            withAnimation {
                                scrollProxy.scrollTo(activeItemID, anchor: .center)
                            }
                        }
                    })
                    
                    Button(action: {
                        if let activeItemID = viewModel.currentItem?.id {
                            withAnimation {
                                scrollProxy.scrollTo(activeItemID, anchor: .center)
                            }
                        }
                    }) {
                        HStack (alignment: .center, spacing: Constants.Design.spacing/4) {
                            Image(systemName: "arrow.down.and.line.horizontal.and.arrow.up")
                            Text(Constants.Placeholders.ActiveWorkout.toActiveItemLabel)
                            Spacer()
                        }
                        .font(.footnote)
                        
                    }
                    .padding(.horizontal, Constants.Design.spacing)
                    .opacity(0.5)
                }
            }
            .adaptiveTint(Constants.Design.Colors.elementFgHighEmphasis)
        }
    }
}

struct ActiveWorkoutView_Previews: PreviewProvider {
    
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        
        let appCoordinator = ApplicationCoordinator(dataContext: persistenceController.container.viewContext)
        let applicationEvent = appCoordinator.applicationEvent
        
        let collectionDataManager = CollectionDataManager()
        let firstCollection = collectionDataManager.fetchFirstUserCollection(in: persistenceController.container.viewContext)
        
        let workoutForPreview = collectionDataManager.fetchWorkouts(for: firstCollection!, in: persistenceController.container.viewContext).first
        
        let workoutUUID = (workoutForPreview?.uuid)!
        
        let activeWorkoutCoordinator = try! ActiveWorkoutCoordinator(dataContext: persistenceController.container.viewContext, activeWorkoutUUID: workoutUUID, applicationEvent: applicationEvent)
        
        ActiveWorkoutView(viewModel: activeWorkoutCoordinator.viewModel)
            .environmentObject(activeWorkoutCoordinator)
    }
}
