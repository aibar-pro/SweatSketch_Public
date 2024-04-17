//
//  ActiveWorkoutExerciseViewModel.swift
//  SweatSketch
//
//  Created by aibaranchikov on 15.04.2024.
//

import Foundation
import ActivityKit

class ActiveWorkoutExerciseViewModel: ObservableObject {
    
    @Published var currentAction: ActiveWorkoutItemActionViewRepresentation?
    @Published var currentActionTimeRemaining: Int = 0
    
    let parentViewModel: ActiveWorkoutViewModel
    
    let exerciseTitle: String
    var actions: [ActiveWorkoutItemActionViewRepresentation]
    
    var isLastAction: Bool {
        return currentAction == actions.last
    }
    var isFirstAction: Bool {
        return currentAction == actions.first
    }
    
    init(parentViewModel: ActiveWorkoutViewModel, exerciseRepresentation: ActiveWorkoutItemViewRepresentation) {
        self.parentViewModel = parentViewModel
        self.exerciseTitle = exerciseRepresentation.title
        self.actions = exerciseRepresentation.actions
        
        if let firstIndex = self.actions.indices.first {
            setCurrentAction(for: self.actions[firstIndex], index: firstIndex)
        }
    }
    
    private func setCurrentAction(for action: ActiveWorkoutItemActionViewRepresentation, index: Int) {
        currentAction = action
        
        if [.timed, .rest].contains(action.type), let actionDuration = action.duration {
            currentActionTimeRemaining = Int(actionDuration)
        }
        
        Task {
            await parentViewModel.updateActivityContent(ActiveWorkoutActionAttributes.ActiveWorkoutActionStatus(action: action, totalActions: actions.count, currentAction: index))
        }
    }

    func nextAction() {
        if let currentAction = self.currentAction, let currentIndex = self.actions.firstIndex(where: {$0 == currentAction }) {
            let nextIndex = min(currentIndex+1, actions.count-1)
            setCurrentAction(for: actions[nextIndex], index: nextIndex)
        }
    }
    
    func previousAction() {
        if let currentAction = self.currentAction, let currentIndex = self.actions.firstIndex(where: {$0 == currentAction }) {
            let nextIndex = max(currentIndex-1, 0)
            setCurrentAction(for: actions[nextIndex], index: nextIndex)
        }
    }
}
