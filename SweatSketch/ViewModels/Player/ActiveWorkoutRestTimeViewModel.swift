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
    
    init(restTimeRepresentation: ActiveWorkoutItemViewRepresentation) {
        self.title = restTimeRepresentation.title
        
        if let restTimeDuration = restTimeRepresentation.restTimeDuration {
            setRestTimeDuration(for: Int(restTimeDuration))
        }
    }
    
    private func setRestTimeDuration(for duration: Int) {
        restTimeRemaining = duration
    }
}
