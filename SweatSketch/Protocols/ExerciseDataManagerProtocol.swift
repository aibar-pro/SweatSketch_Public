//
//  ExerciseDataManagerProtocol.swift
//  SweatSketch
//
//  Created by aibaranchikov on 08.04.2024.
//

import CoreData

protocol ExerciseDataManagerProtocol {
    func fetchExercise(exercise: ExerciseEntity, in context: NSManagedObjectContext) -> ExerciseEntity?
    func fetchExercise(by uuid: UUID, in context: NSManagedObjectContext) -> ExerciseEntity?
    func fetchActions(for exercise: ExerciseEntity, in context: NSManagedObjectContext) -> [ExerciseActionEntity]
    
    func calculateNewActionPosition(for exercise: ExerciseEntity, in context: NSManagedObjectContext) -> Int16
    
    func reindexExercises(for exercise: ExerciseEntity, in context: NSManagedObjectContext)
}
