//
//  WorkoutCarouselView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 06.03.2024.
//

import SwiftUI

struct WorkoutCarouselMainView: View {
        
    @EnvironmentObject var coordinator: WorkoutCarouselCoordinator
    @Environment(\.colorScheme) var colorScheme
    
    //Changes in EnvironmentObject doesn't invalidate the View
    @ObservedObject var viewModel: WorkoutCarouselViewModel
    
    @State var screenTitle: String = Constants.Design.Placeholders.noWorkoutName
    
    var body: some View {
        GeometryReader { geoReader in
            
            if viewModel.workouts.count>0 {
                ZStack {
                    VStack (alignment: .leading, spacing: Constants.Design.spacing) {
                        HStack {
                            Text(screenTitle)
                                .font(.title2.bold())
                                .lineLimit(2)
                                .onAppear(perform: {
                                    if let workoutNameToDisplay = viewModel.workouts[coordinator.presentedWorkoutIndex].name {
                                        screenTitle = workoutNameToDisplay
                                    } else {
                                        screenTitle = Constants.Design.Placeholders.noWorkoutName
                                    }
                                })
                                .onChange(of: coordinator.presentedWorkoutIndex, perform: { newValue in
                                    if let workoutNameToDisplay = viewModel.workouts[newValue].name {
                                        screenTitle = workoutNameToDisplay
                                    } else {
                                        screenTitle = Constants.Design.Placeholders.noWorkoutName
                                    }
                                })
                            
                            
                            Spacer()
                            HStack {
                                Button(action: coordinator.goToAddWorkout, label: {
                                    Image(systemName: "plus")
                                        .font(.title2)
                                })
                                
                                Menu {
                                    Button("Edit workout") {
                                        coordinator.goToEditWorkout()
                                    }
                                    
                                    Button("Reorder or delete workouts") {
                                        coordinator.goToWorkoutLst()
                                    }
                                } label: {
                                    Image(systemName: "ellipsis.circle")
                                        .font(.title2)
                                }
                            }
                        }
                        .padding(.horizontal, Constants.Design.spacing)
                        .frame(height: min(geoReader.size.height*0.1, 55))
                        
                        WorkoutCarouselCardView(viewModel: viewModel, presentedWorkoutIndex: $coordinator.presentedWorkoutIndex)
                    }
                    
                    Button (action: {
                        print("Active workout index: \(coordinator.presentedWorkoutIndex) Workout count: \(viewModel.workouts.count)")
                        coordinator.startWorkout()
                    }) {
                        Text("Go")
                            .accentButtonLabelStyleModifier()
                    }
                    .padding(.top, -50)
                    .frame(width: geoReader.size.width, height: geoReader.size.height, alignment: .bottom)
                }
                .frame(height: geoReader.size.height, alignment: .topLeading)
            } else {
                VStack {
                    Text("No workouts")
                        .font(.title.bold())
                    Button(action: {
                        coordinator.goToAddWorkout()
                        
                    }, label: {
                        Text("Add workout")
                            .accentButtonLabelStyleModifier()
                    })
                }
            }
        }
        .accentColor(Constants.Design.Colors.textColorHighEmphasis)
    }
    
    func setSheetBackgroundColor() {
        if let window = UIApplication.shared.windows.first {
            // For some reason, it picks only light scheme color >.<
            window.backgroundColor = UIColor(colorScheme == .light ?
                                             Constants.Design.Colors.backgroundStartColor : .primary)
        }
    }
}

struct WorkoutCarouselView_Previews: PreviewProvider {
    
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        let appCoordinator = ApplicationCoordinator(dataContext: persistenceController.container.viewContext)
        let workoutEvent = appCoordinator.workoutEvent
        let carouselCoordinator = WorkoutCarouselCoordinator(dataContext: persistenceController.container.viewContext, workoutEvent: workoutEvent)
        
        WorkoutCarouselMainView(viewModel: carouselCoordinator.viewModel)
            .environmentObject(carouselCoordinator)
    }
}
