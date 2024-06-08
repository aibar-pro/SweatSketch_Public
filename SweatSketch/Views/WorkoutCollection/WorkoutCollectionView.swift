//
//  WorkoutCollectionView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 06.03.2024.
//

import SwiftUI

struct WorkoutCollectionView: View {
        
    @EnvironmentObject var coordinator: WorkoutCollectionCoordinator
    @Environment(\.colorScheme) var colorScheme
    
    //Changes in EnvironmentObject doesn't invalidate the View
    @ObservedObject var viewModel: WorkoutCollectionViewModel
    
    @State var presentedWorkoutIndex: Int = 0
    
    var body: some View {
        VStack (spacing: Constants.Design.spacing/2) {
            HStack (alignment: .center) {
                Button (action: {
                    coordinator.enterCollections()
                }) {
                    HStack {
                        Image(systemName: "chevron.backward")
                        Text(Constants.Placeholders.WorkoutCollection.toCatalogButtonLabel)
                    }
                    .padding(.vertical, Constants.Design.spacing/2)
                    .padding(.trailing, Constants.Design.spacing/2)
                }
                
                Spacer()
                
                HStack {
                    Button(action: {
                        coordinator.goToAddWorkout()
                    }) {
                        Image(systemName: "plus")
                            .padding(.vertical, Constants.Design.spacing/2)
                            .padding(.horizontal, Constants.Design.spacing/2)
                    }
                    
                    
                    Menu {
                        Button(Constants.Placeholders.WorkoutCollection.editWorkoutButtonLabel) {
                            coordinator.goToEditWorkout(workoutIndex: presentedWorkoutIndex)
                        }
                        
                        Button(Constants.Placeholders.WorkoutCollection.listWorkoutButtonLabel) {
                            coordinator.goToWorkoutLst()
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .padding(.vertical, Constants.Design.spacing/2)
                            .padding(.leading, Constants.Design.spacing/2)
                    }
                    .disabled(isCarouselDisabled())
                }
            }
            .font(.title3)
            .padding(.horizontal, Constants.Design.spacing)
            
            GeometryReader { geoReader in
                if !isCarouselDisabled() {
                    ZStack {
                        VStack (alignment: .leading, spacing: Constants.Design.spacing/2) {
                            
                            Text(viewModel.workouts[presentedWorkoutIndex].name)
                                .font(.title2.bold())
                                .lineLimit(2)
                                .padding(.horizontal, Constants.Design.spacing)
                                .frame(height: min(geoReader.size.height*0.1, 55)) //no preserve space in iOS14
                            
                            WorkoutCollectionCarouselView(viewModel: viewModel, presentedWorkoutIndex: $presentedWorkoutIndex)
                        }
                        
                        Button (action: {
                            coordinator.startWorkout(workoutIndex: presentedWorkoutIndex)
                        }) {
                            Text(Constants.Placeholders.WorkoutCollection.startWorkoutButtonLabel)
                                .accentButtonLabelStyleModifier()
                        }
                        .padding(.top, -50)
                        .frame(width: geoReader.size.width, height: geoReader.size.height, alignment: .bottom)
                    }
                } else {
                    VStack {
                        Text(Constants.Placeholders.WorkoutCollection.emptyCollectionText)
                            .font(.title.bold())
                        Button(action: {
                            coordinator.goToAddWorkout()
                            
                        }, label: {
                            Text(Constants.Placeholders.WorkoutCollection.emptyCollectionButtonLabel)
                                .accentButtonLabelStyleModifier()
                        })
                    }
                    .frame(width: geoReader.size.width, height: geoReader.size.height, alignment: .center)
                }
            }
        }
        .accentColor(Constants.Design.Colors.textColorHighEmphasis)
    }
    
    func isCarouselDisabled() -> Bool {
        return viewModel.workouts.isEmpty
    }
    
    func setSheetBackgroundColor() {
        if let window = UIApplication.shared.windows.first {
            // For some reason, it picks only light scheme color >.<
            window.backgroundColor = UIColor(colorScheme == .light ?
                                             Constants.Design.Colors.backgroundStartColor : .primary)
        }
    }
}

struct WorkoutCollectionView_Previews: PreviewProvider {
    
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        let appCoordinator = ApplicationCoordinator(dataContext: persistenceController.container.viewContext)
        let applicationEvent = appCoordinator.applicationEvent
        let carouselCoordinator = WorkoutCollectionCoordinator(dataContext: persistenceController.container.viewContext, applicationEvent: applicationEvent, collectionUUID: nil)
        
        WorkoutCollectionView(viewModel: carouselCoordinator.viewModel, presentedWorkoutIndex: 0)
            .environmentObject(carouselCoordinator)
    }
}
