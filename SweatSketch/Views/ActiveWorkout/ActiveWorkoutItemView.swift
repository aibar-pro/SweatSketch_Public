//
//  ActiveWorkoutItemView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 25.05.2024.
//

import SwiftUI

struct ActiveWorkoutItemView: View {
    var workoutItem: ActiveWorkoutItemRepresentation
    @Binding var itemProgress: (current: Int, total: Int)
    
    var nextRequested: () -> ()
    var previousRequested: () -> ()
    
    var body: some View {
        VStack (alignment: .leading, spacing: Constants.Design.spacing/2) {
            HStack(alignment: .top) {
                let currentAction = workoutItem.actions[itemProgress.current]
                
                VStack (alignment: .leading, spacing: Constants.Design.spacing/2) {
                    Text(currentAction.title)
                        .font(.headline.bold())
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                    if workoutItem.title != currentAction.title {
                        Text(workoutItem.title)
                            .font(.subheadline)
                            .lineLimit(1)
                            .multilineTextAlignment(.leading)
                    }
                }
                
                Spacer()
                
                switch currentAction.type {
                case .setsNreps:
                    if let repsMax = currentAction.repsMax, repsMax {
                        Text("x\(Constants.Placeholders.maximumRepetitionsLabel)")
                            .font(.headline.bold())
                    } else if let reps = currentAction.reps {
                        Text("x\(reps)")
                            .font(.headline.bold())
                    }
                default:
                    if let actionDuration = currentAction.duration {
                        CountdownTimerView(timeRemaining: Int(actionDuration))
                            .font(.headline.bold())
                    }
                }
            }
            
            ProgressBarView(totalSections: itemProgress.total, currentSection: itemProgress.current)
//            ProgressBarView(totalSections: itemProgressTotal, currentSection: itemProgressCurrent)
                .frame(height: 28)
            
            HStack (alignment: .center, spacing: Constants.Design.spacing/2) {
                Button(action: previousRequested){
                    Image(systemName: "chevron.backward")
                        .secondaryButtonLabelStyleModifier()
                }
                
                Spacer()
                
                Button(action: nextRequested){
                    Image(systemName: "chevron.forward")
                        .padding(.horizontal, Constants.Design.spacing)
                        .primaryButtonLabelStyleModifier()
                }
            }
        }
    }
}

struct ActiveWorkoutItemView_Previews: PreviewProvider {
    
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        
        let appCoordinator = ApplicationCoordinator(dataContext: persistenceController.container.viewContext)
        let applicationEvent = appCoordinator.applicationEvent
        
        let collectionDataManager = CollectionDataManager()
        let firstCollection = collectionDataManager.fetchFirstUserCollection(in: persistenceController.container.viewContext)
        
        let workoutForPreview = collectionDataManager.fetchWorkouts(for: firstCollection!, in: persistenceController.container.viewContext).first
        
        let exerciseForPreview = try! ActiveWorkoutRepresentation(workoutUUID: (workoutForPreview?.uuid)!, in: persistenceController.container.viewContext).items[2]
        
        ActiveWorkoutItemView(workoutItem: exerciseForPreview, itemProgress: .constant((5,10)), nextRequested: {}, previousRequested: {})
    }
}
