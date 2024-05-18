//
//  ActiveWorkoutRestTimeViewModel.swift
//  SweatSketch
//
//  Created by aibaranchikov on 16.04.2024.
//

import Foundation

class ActiveWorkoutRestTimeViewModel: ObservableObject {
    @Published var restTimeRemaining: Int = 0
    let title: String
    
    let parentViewModel: ActiveWorkoutViewModel
    
    init(parentViewModel: ActiveWorkoutViewModel, restTimeRepresentation: ActiveWorkoutItemViewRepresentation) {
        self.parentViewModel = parentViewModel
        
        self.title = restTimeRepresentation.title
        
        if let restTimeDuration = restTimeRepresentation.restTimeDuration {
            setRestTimeDuration(for: Int(restTimeDuration))
            Task {
                await parentViewModel.updateActivityContent(ActiveWorkoutActionAttributes.ActiveWorkoutActionStatus(title: restTimeRepresentation.title, duration: Int(restTimeDuration), totalActions: 1, currentAction: 0))
            }
        } else {
            Task {
                await parentViewModel.updateActivityContent(ActiveWorkoutActionAttributes.ActiveWorkoutActionStatus(title: restTimeRepresentation.title, duration: nil, totalActions: 1, currentAction: 0))
            }
        }
        
        
    }
    
    private func setRestTimeDuration(for duration: Int) {
        restTimeRemaining = duration
    }
}
