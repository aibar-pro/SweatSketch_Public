//
//  ActiveWorkoutRestTimeView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 04.04.2024.
//

import SwiftUI

struct ActiveWorkoutRestTimeView: View {
    
    @ObservedObject var viewModel: ActiveWorkoutRestTimeViewModel
    
    var doneRequested: () -> ()
    var returnRequested: () -> ()
    
    var body: some View {
        VStack (alignment: .leading, spacing: Constants.Design.spacing){
            HStack (alignment: .top) {
                Text(viewModel.title)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                CountdownTimerView(timeRemaining: $viewModel.restTimeRemaining)
            }
            .font(.headline.bold())
            
            HStack (alignment: .top, spacing: Constants.Design.spacing/2) {
                Button(action: { returnRequested() }){
                    Image(systemName: "chevron.backward")
                        .secondaryButtonLabelStyleModifier()
                }
                Spacer()
                Button(action: { doneRequested() }){
                    Image(systemName: "chevron.forward")
                        .padding(.horizontal, Constants.Design.spacing)
                        .primaryButtonLabelStyleModifier()
                }
            }
        }
    }
}

struct ActiveWorkoutRestTimeView_Previews: PreviewProvider {
    
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        
        let appCoordinator = ApplicationCoordinator(dataContext: persistenceController.container.viewContext)
        let applicationEvent = appCoordinator.applicationEvent
        
        let collectionDataManager = CollectionDataManager()
        let firstCollection = collectionDataManager.fetchFirstUserCollection(in: persistenceController.container.viewContext)
        
        let workoutForPreview = collectionDataManager.fetchWorkouts(for: firstCollection!, in: persistenceController.container.viewContext).first
        
        let workoutUUID = (workoutForPreview?.uuid)!
        
        let activeWorkoutCoordinator = try! ActiveWorkoutCoordinator(dataContext: persistenceController.container.viewContext, activeWorkoutUUID: workoutUUID, applicationEvent: applicationEvent)
        
        let restTimeForPreview = try! ActiveWorkoutViewRepresentation(workoutUUID: (workoutForPreview?.uuid)!, in: persistenceController.container.viewContext).items[1]
        
        let restTimeModel = ActiveWorkoutRestTimeViewModel(parentViewModel: activeWorkoutCoordinator.viewModel, restTimeRepresentation: restTimeForPreview)
        
        ActiveWorkoutRestTimeView(viewModel: restTimeModel, doneRequested: {}, returnRequested: {})
    }
}

