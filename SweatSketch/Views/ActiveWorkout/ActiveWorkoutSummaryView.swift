//
//  ActiveWorkoutSummaryView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 16.04.2024.
//

import SwiftUI

struct ActiveWorkoutSummaryView: View {
    @EnvironmentObject var coordinator: ActiveWorkoutCoordinator
    let workoutDuration: Int
    
    var onProceed: () -> Void = {}
    var onDismiss: () -> Void = {}
    
    var body: some View {
        VStack(alignment: .center, spacing: Constants.Design.spacing) {
            Text(Constants.Placeholders.workoutSummaryTitle)
                .fullWidthText(.title, weight: .bold, alignment: .center)
            
            HStack(alignment: .center, spacing: Constants.Design.spacing / 2) {
                Image(systemName: "timer")
                Text(workoutDuration.durationString())
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
            RectangleButton(
                "active.workout.summary.proceed.button.label",
                style: .accent,
                isFullWidth: true,
                action: {
                    onProceed()
                }
            )
        }
        .padding(Constants.Design.spacing)
        .materialBackground()
        .lightShadow()
        .padding(Constants.Design.spacing)
        .frame(maxHeight: .infinity, alignment: .center)
        .background(
            ActiveWorkoutSummaryBackgroundView()
        )
        .onDisappear(perform: onDismiss)
    }
}

struct ActiveWorkoutCompletedView_Previews: PreviewProvider {
    
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        
        let appCoordinator = ApplicationCoordinator(dataContext: persistenceController.container.viewContext)
        let applicationEvent = appCoordinator.applicationEvent
        
        let collectionDataManager = CollectionDataManager()
        let firstCollection = collectionDataManager.fetchFirstUserCollection(in: persistenceController.container.viewContext)
        
        let workoutForPreview = collectionDataManager.fetchWorkouts(for: firstCollection!, in: persistenceController.container.viewContext).first
        
        let workoutUUID = (workoutForPreview?.uuid)!
        
        let activeWorkoutCoordinator = try! ActiveWorkoutCoordinator(dataContext: persistenceController.container.viewContext, activeWorkoutUUID: workoutUUID, applicationEvent: applicationEvent)
        
        ActiveWorkoutSummaryView(workoutDuration: 100)
            .environmentObject(activeWorkoutCoordinator)
    }
}
