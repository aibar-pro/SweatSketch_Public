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
                        .font(.title2.bold())
                        .lineLimit(2)
                    
                    Spacer()
                    
                    Button(action: {
                        coordinator.finishWorkout()
                    }) {
                        Image(systemName: "stop")
                            .secondaryButtonLabelStyleModifier()
                    }
                }
                .padding(.horizontal, Constants.Design.spacing)
                
                ScrollViewReader { scrollProxy in
                        Button("To active item") {
                            if let activeItemID = viewModel.activeItem?.id {
                                withAnimation {
                                    scrollProxy.scrollTo(activeItemID, anchor: .center)
                                }
                            }
                        }

                    ScrollView {
                        VStack (alignment: .center, spacing: Constants.Design.spacing) {
                            ForEach(viewModel.items, id: \.id) { item in
                                if viewModel.isActiveItem(item: item) {
                                    switch item.type {
                                    case .exercise:
                                        ActiveWorkoutExerciseView(viewModel: ActiveWorkoutExerciseViewModel(exerciseRepresentation: item), doneRequested: {
                                            viewModel.nextItem()
                                        }, returnRequested: {
                                            viewModel.previousItem()
                                        })
                                        .id(item.id)
                                        .padding(Constants.Design.spacing)
                                        .materialCardBackgroundModifier()
                                        .padding(.horizontal, Constants.Design.spacing)
                                        
                                    case .rest:
                                        ActiveWorkoutRestTimeView(restTime: item, doneRequested: {
                                            viewModel.nextItem()
                                        }, returnRequested: {
                                            viewModel.previousItem()
                                        })
                                        .id(item.id)
                                        .padding(Constants.Design.spacing)
                                        .materialCardBackgroundModifier()
                                    }
                                } else {
                                    Text(item.title)
                                        .font(.subheadline)
                                        .lineLimit(3)
                                        .multilineTextAlignment(.center)
                                        .padding(Constants.Design.spacing)
                                        .materialCardBackgroundModifier()
                                        .opacity(0.4)
                                        .id(item.id)
                                }
                                
                            }
//                                VStack (alignment: .center, spacing: Constants.Design.spacing) {
//                                    if viewModel.isActiveItem(item: item) {
//                                        switch item.type {
//                                        case .exercise:
//                                            if let exercise = viewModel.getExercise(from: item) {
//                                                ActiveWorkoutExerciseView(exercise: exercise, doneRequested: {
//                                                    viewModel.nextItem()
//                                                    
//                                                }, returnRequested: {
//                                                    viewModel.previousItem()
//                                                })
//                                                .frame(width: gReader.size.width * 0.75)
//                                            }
//                                        case .rest:
//                                                ActiveWorkoutRestTimeView(restTime: item, doneRequested: {
//                                                    viewModel.nextItem()
//                                                }, returnRequested: {
//                                                    viewModel.previousItem()
//                                                })
//                                                .frame(width: gReader.size.width * 0.6)
//                                        case .none:
//                                            ErrorMessageView(text: Constants.Placeholders.activeWorkoutItemError)
//                                                .fixedSize()
//                                        }
//                                    } else {
//                                        Text(item.name)
//                                            .font(.subheadline)
//                                            .lineLimit(3)
//                                            .multilineTextAlignment(.center)
//                                    }
//                                }
//                                .id(item.id)
//                                .padding(Constants.Design.spacing)
//                                .materialCardBackgroundModifier()
//                                .opacity(viewModel.isActiveItem(item: item) ? 1 : 0.4)
//                                
//                            }
                        }
                    }
                    .onChange(of: viewModel.activeItem) { _ in
                        if let activeItemID = viewModel.activeItem?.id {
                            withAnimation {
                                scrollProxy.scrollTo(activeItemID, anchor: .center)
                            }
                        }
                    }
                    .onAppear(perform: {
                        if let activeItemID = viewModel.activeItem?.id {
                            withAnimation {
                                scrollProxy.scrollTo(activeItemID, anchor: .center)
                            }
                        }
                    })
                }
            }
            .accentColor(Constants.Design.Colors.textColorHighEmphasis)
        }
    }
}

struct ActiveWorkoutView_Previews: PreviewProvider {
    
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        
        let appCoordinator = ApplicationCoordinator(dataContext: persistenceController.container.viewContext)
        let workoutEvent = appCoordinator.workoutEvent
        
        let collectionDataManager = CollectionDataManager()
        let firstCollection = collectionDataManager.fetchFirstUserCollection(in: persistenceController.container.viewContext)
        
        let workoutForPreview = collectionDataManager.fetchWorkouts(for: firstCollection!, in: persistenceController.container.viewContext).first
        
        let workoutUUID = (workoutForPreview?.uuid)!
        
        let activeWorkoutCoordinator = try! ActiveWorkoutCoordinator(dataContext: persistenceController.container.viewContext, activeWorkoutUUID: workoutUUID, workoutEvent: workoutEvent)
        
        ActiveWorkoutView(viewModel: activeWorkoutCoordinator.viewModel)
            .environmentObject(activeWorkoutCoordinator)
    }
}
