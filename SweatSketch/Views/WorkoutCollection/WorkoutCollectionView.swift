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
    
    //Changes in EnvironmentObject don't invalidate the View
    @ObservedObject var viewModel: WorkoutCollectionViewModel
    
    @State var presentedWorkoutIndex: Int = 0
    
    var body: some View {
        content
            .onAppear {
                viewModel.refreshData()
            }
    }
    
    private var content: some View {
        VStack(alignment: .center, spacing: Constants.Design.spacing) {
            toolbar
                .padding(.horizontal, Constants.Design.spacing)
            
            if !isCarouselHidden {
                workoutCarousel
            } else {
                emptyView
            }
        }
    }
    
    private var toolbar: some View {
        HStack(alignment: .center, spacing: Constants.Design.spacing / 2) {
            catalogButton
            Spacer(minLength: 0)
            editWorkoutButton
            collectionMenuButton
        }
    }
    
    private var editWorkoutButton: some View {
        IconButton(
            systemImage: "pencil",
            style: .secondary,
            action: {
                coordinator.goToEditWorkout(workoutIndex: presentedWorkoutIndex)
            }
        )
    }
    
    private var collectionMenuButton: some View {
        MenuButton(
            style: .secondary,
            isDisabled: Binding { isCarouselHidden } set: { _ in }
        ) {
            Button(action: {
                coordinator.goToAddWorkout()
            }) {
                Text("collection.add.workout.button.label")
            }
            Button(action: {
                coordinator.goToWorkoutLst()
            }) {
                Text("collection.edit.list.button.label")
            }
        }
    }
    
    private var catalogButton: some View {
        IconButton(
            systemImage: "menucard",
            style: .secondary,
            action: {
                coordinator.goToCatalog()
            }
        )
    }
    
    private var workoutCarousel: some View {
        ZStack(alignment: .bottom) {
            VStack (alignment: .leading, spacing: Constants.Design.spacing) {
                Text(viewModel.workouts[presentedWorkoutIndex].name)
                    .fullWidthText(.title2, weight: .bold)
                    .lineLimit(3)
                    .padding(.horizontal, Constants.Design.spacing)

                WorkoutCollectionCarouselView(
                    viewModel: viewModel,
                    presentedWorkoutIndex: $presentedWorkoutIndex
                )
            }

            RectangleButton(
                "collection.start.workout.button.label",
                style: .accent,
                action: {
                    coordinator.startWorkout(workoutIndex: presentedWorkoutIndex)
                }
            )
            .offset(y: -Constants.Design.spacing)
        }
    }
    
    private var emptyView: some View {
        VStack(alignment: .center, spacing: Constants.Design.spacing) {
            Text("collection.empty.label")
                .fullWidthText(.title2, weight: .bold, alignment: .center)
            
            RectangleButton(
                "collection.add.workout.button.label",
                style: .accent,
                action: {
                    coordinator.goToAddWorkout()
                }
            )
        }
        .frame(maxHeight: .infinity, alignment: .center)
    }
    
    var isCarouselHidden: Bool {
        viewModel.workouts.isEmpty
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
