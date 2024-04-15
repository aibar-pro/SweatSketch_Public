//
//  ActiveWorkoutRestTimeView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 04.04.2024.
//

import SwiftUI

struct ActiveWorkoutRestTimeView: View {
    
    let restTime: ActiveWorkoutItemViewRepresentation
    var doneRequested: () -> ()
    var returnRequested: () -> ()
    
    var body: some View {
        HStack (alignment: .top, spacing: Constants.Design.spacing/2) {
            Button(action: { returnRequested() }){
                Image(systemName: "chevron.backward")
                    .secondaryButtonLabelStyleModifier()
            }
            Spacer()
            VStack (alignment: .center, spacing: Constants.Design.spacing/2) {
                Text(restTime.title)
                    .font(.headline.bold())
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                
                if let timeRemaining = restTime.restTimeDuration {
                    CountdownTimerView(timeRemaining: Int(timeRemaining))
                }
            }
            Spacer()
            
            Button(action: { doneRequested() }){
                Image(systemName: "chevron.forward")
                    .primaryButtonLabelStyleModifier()
            }
        }
    }
}

struct ActiveWorkoutRestTimeView_Previews: PreviewProvider {
    
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        
        let collectionDataManager = CollectionDataManager()
        let firstCollection = collectionDataManager.fetchFirstUserCollection(in: persistenceController.container.viewContext)
        
        let workoutForPreview = collectionDataManager.fetchWorkouts(for: firstCollection!, in: persistenceController.container.viewContext).first
        
        let restTimeForPreview = try! ActiveWorkoutViewRepresentation(workoutUUID: (workoutForPreview?.uuid)!, in: persistenceController.container.viewContext).items[1]
        
        ActiveWorkoutRestTimeView(restTime: restTimeForPreview, doneRequested: {}, returnRequested: {})
    }
}

