//
//  ExerciseViewModel.swift
//  SweatSketch
//
//  Created by aibaranchikov on 09.04.2024.
//

import CoreData

class ExerciseViewRepresentation: Identifiable, Equatable, ObservableObject {
    static func == (lhs: ExerciseViewRepresentation, rhs: ExerciseViewRepresentation) -> Bool {
        return 
            lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.type == rhs.type &&
            lhs.actions == rhs.actions &&
            lhs.restTimeBetweenActions == rhs.restTimeBetweenActions &&
            lhs.superSets == rhs.superSets
    }
    
    let id: UUID
    var name: String
    var type: ExerciseType
    var actions = [ExerciseActionViewRepresentation]()
    var restTimeBetweenActions: ExerciseActionEntity?
    var superSets: Int16
    
    private let exerciseDataManager = ExerciseDataManager()
    
    init?(exercise: ExerciseEntity, in context: NSManagedObjectContext) {
        guard let id = exercise.uuid else { return nil }
        self.id = id
        self.name = exercise.name ?? Constants.Placeholders.noExerciseName
        self.type = ExerciseType.from(rawValue: exercise.type)
        
        let fetchedActions = exerciseDataManager.fetchActions(for: exercise, in: context)
        self.actions = fetchedActions.compactMap({ $0.toExerciseActionViewRepresentation() })
        
        self.restTimeBetweenActions = exerciseDataManager.fetchRestTimeBetweenActions(for: exercise, in: context) ?? ExerciseActionEntity()
        self.superSets = exercise.superSets
    }
}

extension ExerciseEntity {
    func toExerciseViewRepresentation() -> ExerciseViewRepresentation? {
        guard let context = self.managedObjectContext else {
            return nil
        }
        return ExerciseViewRepresentation(exercise: self, in: context)
    }
}
