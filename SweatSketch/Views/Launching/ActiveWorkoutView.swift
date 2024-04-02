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
        let items = viewModel.items
        
        GeometryReader { gReader in
            VStack (alignment: .center, spacing: Constants.Design.spacing) {
                
                HStack{
                    Text(viewModel.activeWorkout?.name ?? Constants.Design.Placeholders.noWorkoutName)
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
                
                GeometryReader { timelineGeometry in
                    ScrollViewReader { scrollProxy in
                        Button("Go to active item") {
                            if let activeItemID = viewModel.activeItem?.id {
                                withAnimation {
                                    scrollProxy.scrollTo(activeItemID, anchor: .center)
                                }
                            }
                        }

                        ScrollView {
                            VStack (spacing: Constants.Design.spacing) {
                                ForEach(items, id: \.id) { item in
                                    VStack (alignment: .center, spacing: Constants.Design.spacing) {
                                        HStack (alignment: .center, spacing: Constants.Design.spacing/2) {
                                            if viewModel.isActiveItem(item: item) {
                                                VStack {
                                                    Button(action: {
                                                        viewModel.previousItem()
                                                    }) {
                                                        Image(systemName: "chevron.backward")
                                                            .secondaryButtonLabelStyleModifier()
                                                    }
                                                    Spacer()
                                                }
                                            }
                                            Spacer()
                                            
                                            VStack (alignment: .center, spacing: Constants.Design.spacing) {
                                                Text(item.name ?? Constants.Design.Placeholders.noActionName)
                                                    .font(viewModel.isActiveItem(item: item) ? .headline.bold() : .subheadline)
                                                    .lineLimit(3)
                                                    .multilineTextAlignment(.center)
                                               
                                                if viewModel.isActiveItem(item: item) {
                                                    switch item.type {
                                                    case .rest, .timed:
                                                        if let duration = item.duration {
                                                            DurationView(durationInSeconds: Int(duration))
                                                        }
                                                    case .reps:
                                                        if let reps = item.reps {
                                                            Text("x\(reps)")
                                                        } else if let repsmax = item.repsMax {
                                                            Text ("MAX")
                                                        }
                                                    default:
                                                        EmptyView()
                                                    }
                                                    
                                                }
                                            }
                                            
                                            Spacer()
                                            if viewModel.isActiveItem(item: item) {
                                                
                                                Button(action: {
                                                    viewModel.nextItem()
                                                }) {
                                                    Image(systemName: "chevron.forward")
                                                        .font(.headline.bold())
                                                        .frame(height: 150 - 3.5 * Constants.Design.spacing)
                                                        .primaryButtonLabelStyleModifier()
                                                }
                                            }
                                        }
                                    }
                                    .id(item.id)
                                    .padding(Constants.Design.spacing)
                                    .frame(width: timelineGeometry.size.width * (viewModel.isActiveItem(item: item) ? 1 : 0.75) - 2 * Constants.Design.spacing, height: viewModel.isActiveItem(item: item) ? 150 : 75, alignment: .top)
                                    .materialCardBackgroundModifier()
                                    .opacity(viewModel.isActiveItem(item: item) ? 1 : 0.4)
                                }
                            }
                            
                        }
                        .padding(.horizontal, Constants.Design.spacing)
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
}

struct ActiveWorkoutView_Previews: PreviewProvider {
    
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        
        let appCoordinator = ApplicationCoordinator(dataContext: persistenceController.container.viewContext)
        let workoutEvent = appCoordinator.workoutEvent
        
        let workoutViewModel = WorkoutCarouselViewModel(context: persistenceController.container.viewContext)
        let workoutUUID = workoutViewModel.workouts[0].uuid!
        
        let activeWorkoutCoordinator = ActiveWorkoutCoordinator(dataContext: persistenceController.container.viewContext, activeWorkoutUUID: workoutUUID, workoutEvent: workoutEvent)
        
        ActiveWorkoutView(viewModel: activeWorkoutCoordinator.viewModel)
            .environmentObject(activeWorkoutCoordinator)
    }
}
