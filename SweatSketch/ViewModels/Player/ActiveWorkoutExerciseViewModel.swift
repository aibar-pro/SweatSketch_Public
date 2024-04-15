//
//  ActiveWorkoutExerciseViewModel.swift
//  SweatSketch
//
//  Created by aibaranchikov on 15.04.2024.
//

import Foundation

class ActiveWorkoutExerciseViewModel: ObservableObject {
    
    @Published var currentAction: ActiveWorkoutItemActionViewRepresentation?
    @Published var currentActionTimeRemaining: Int = 0
    
    let exerciseTitle: String
    var actions: [ActiveWorkoutItemActionViewRepresentation]
    
    var isLastAction: Bool {
        return currentAction == actions.last
    }
    var isFirstAction: Bool {
        return currentAction == actions.first
    }
    
    init(exerciseRepresentation: ActiveWorkoutItemViewRepresentation) {
        self.exerciseTitle = exerciseRepresentation.title
        self.actions = exerciseRepresentation.actions
        
        if let firstAction = self.actions.first {
            setCurrentAction(for: firstAction)
        }
    }
    
    private func setCurrentAction(for action: ActiveWorkoutItemActionViewRepresentation) {
        currentAction = action
        if [.timed, .rest].contains(action.type), let actionDuration = action.duration {
            currentActionTimeRemaining = Int(actionDuration)
        }
    }

    func nextAction() {
        if let currentAction = self.currentAction, let currentIndex = self.actions.firstIndex(where: {$0 == currentAction }) {
            let nextIndex = min(currentIndex+1, actions.count-1)
            setCurrentAction(for: actions[nextIndex])
        }
    }
    
    func previousAction() {
        if let currentAction = self.currentAction, let currentIndex = self.actions.firstIndex(where: {$0 == currentAction }) {
            let nextIndex = max(currentIndex-1, 0)
            setCurrentAction(for: actions[nextIndex])
        }
    }
}
