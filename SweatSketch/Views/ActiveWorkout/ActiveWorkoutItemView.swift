//
//  ActiveWorkoutItemView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 25.05.2024.
//

import SwiftUI

struct ActiveWorkoutItemView: View {
    var workoutItem: ActiveWorkoutItem
    @Binding var itemProgress: (current: Int, total: Int)
    
    var nextRequested: () -> ()
    var previousRequested: () -> ()
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.Design.spacing) {
            if let currentAction = workoutItem.actions[safe: itemProgress.current] {
                itemDescriptionView(currentAction: currentAction)
            
                ProgressBarView(totalSections: itemProgress.total, currentSection: itemProgress.current)
                    .frame(height: 28)
            }
            
            buttonStackView
        }
    }
    
    private func itemDescriptionView(currentAction: ActionViewRepresentation) -> some View {
        HStack(alignment: .top, spacing: Constants.Design.spacing) {
            VStack(alignment: .leading, spacing: Constants.Design.spacing) {
                if workoutItem.title != currentAction.title {
                    Text(workoutItem.title)
                        .font(.title3.bold())
                        .lineLimit(1)
                        .multilineTextAlignment(.leading)
                }
                
                Text(currentAction.title)
                    .font(workoutItem.title != currentAction.title ? .headline : .title3.bold())
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer(minLength: 0)
            
            switch currentAction.type {
            case .reps(_, let min, let max, let isMax):
                Group {
                    if isMax {
                        Text("x\(Constants.Placeholders.maximumRepetitionsLabel)")
                    } else if let max {
                        Text("x\(min)-\(max)")
                    } else {
                        Text("x\(min)")
                    }
                }
                .font(.title3.bold())
            case .rest(let duration):
                CountdownTimerView(timeRemaining: duration)
                    .font(.title3.bold())
            default: EmptyView()
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
        
        ActiveWorkoutItemView(workoutItem: exerciseForPreview, itemProgress: .constant((5,10)), nextRequested: {}, previousRequested: {})
    }
}
