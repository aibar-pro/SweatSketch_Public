//
//  ExerciseActionViewRepresentation.swift
//  SweatSketch
//
//  Created by aibaranchikov on 10.04.2024.
//

import Foundation

class ExerciseActionViewViewModel: Identifiable, Equatable, ObservableObject {
    static func == (lhs: ExerciseActionViewViewModel, rhs: ExerciseActionViewViewModel) -> Bool {
        return 
            lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.type == rhs.type &&
            lhs.duration == rhs.duration &&
            lhs.sets == rhs.sets &&
            lhs.reps == rhs.reps &&
            lhs.repsMax == rhs.repsMax
    }
    
    let id: UUID
    var name: String
    var type: ExerciseActionType
    var duration: Int32
    var sets: Int16
    var reps: Int16
    var repsMax: Bool
    
    init?(action: ExerciseActionEntity) {
        guard let id = action.uuid else { return nil }
        self.id = id
        self.name = action.name ?? Constants.Placeholders.noActionName
        self.type = ExerciseActionType.from(rawValue: action.type)
        
        self.duration = action.duration
        self.sets = action.sets
        self.reps = action.reps
        self.repsMax = action.repsMax
    }
}

extension ExerciseActionEntity {
    func toExerciseActionViewRepresentation() -> ExerciseActionViewViewModel? {
        return ExerciseActionViewViewModel(action: self)
    }
}
