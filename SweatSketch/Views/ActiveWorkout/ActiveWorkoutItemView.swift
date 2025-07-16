//
//  ActiveWorkoutItemView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 25.05.2024.
//

import SwiftUI

struct ActiveWorkoutItemView: View {
    var workoutItem: ActiveWorkoutItem
    @Binding var itemProgress: ItemProgress
    
    var nextRequested: () -> Void
    var previousRequested: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.Design.spacing) {
            if let currentAction = workoutItem.actions[safe: itemProgress.stepIndex] {
                itemDescriptionView(currentAction: currentAction)
            
                ProgressBarView(itemProgress: itemProgress)
                    .frame(height: Constants.Design.spacing * 1.5)
            }
            
            buttonStackView
        }
    }
    
    private func itemDescriptionView(currentAction: ActionRepresentation) -> some View {
        VStack(alignment: .leading, spacing: Constants.Design.spacing) {
            HStack(alignment: .firstTextBaseline, spacing: Constants.Design.spacing) {
                Text(workoutItem.title)
                    .lineLimit(1)
                
                Spacer(minLength: 0)
                
                Text(itemProgress.stepProgress.quantity)
                    .lineLimit(1)
            }
            .font(.title3.bold())
            
            if workoutItem.title != currentAction.title,
               currentAction.title.isEmpty == false {
                Text(currentAction.title)
                    .font(workoutItem.title != currentAction.title ? .headline : .title3.bold())
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
            }
        }
    }
    
    private var buttonStackView: some View {
        HStack(alignment: .center, spacing: Constants.Design.spacing) {
            CapsuleButton(
                content: {
                    Image(systemName: "chevron.backward")
                },
                style: .inline,
                action: {
                    previousRequested()
                }
            )
            
            Spacer(minLength: 0)
            
            CapsuleButton(
                content: {
                    Image(systemName: "chevron.forward")
                },
                style: .primary,
                action: {
                    nextRequested()
                }
            )
        }
    }
}

struct ActiveWorkoutItemView_Previews: PreviewProvider {
    
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        
        let collectionDataManager = CollectionDataManager()
        let firstCollection = collectionDataManager.fetchFirstUserCollection(in: persistenceController.container.viewContext)
        
        let workoutForPreview = collectionDataManager.fetchWorkouts(for: firstCollection!, in: persistenceController.container.viewContext).first
        
        let exerciseForPreview = try! ActiveWorkoutRepresentation(workoutUUID: (workoutForPreview?.uuid)!, in: persistenceController.container.viewContext).items[2]
        
        ActiveWorkoutItemView(
            workoutItem: exerciseForPreview,
            itemProgress: .constant(.init()),
            nextRequested: {},
            previousRequested: {}
        )
    }
}
