//
//  ActiveWorkoutExerciseViewModel.swift
//  SweatSketch
//
//  Created by aibaranchikov on 15.04.2024.
//

import Foundation

class ActiveWorkoutExerciseViewModel: ObservableObject {
    
    @Published var currentAction: ActiveWorkoutItemActionViewRepresentation?
    
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
        
        self.currentAction = self.actions.first
    }

    func nextAction() {
        if let currentAction = self.currentAction, let currentIndex = self.actions.firstIndex(where: {$0 == currentAction }) {
            let nextIndex = min(currentIndex+1, actions.count-1)
            self.currentAction = actions[nextIndex]
        }
    }
    
    func previousAction() {
        if let currentAction = self.currentAction, let currentIndex = self.actions.firstIndex(where: {$0 == currentAction }) {
            let nextIndex = max(currentIndex-1, 0)
            self.currentAction = actions[nextIndex]
        }
    }
}
