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
    
    var body: some View {
        VStack {
            Text(viewModel.activeWorkout?.name ?? Constants.Design.Placeholders.noWorkoutName)
            HStack{
                Button("Stop") {
                    coordinator.finishWorkout()
                }
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
