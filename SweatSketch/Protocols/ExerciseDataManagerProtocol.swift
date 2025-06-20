//
//  ExerciseDataManagerProtocol.swift
//  SweatSketch
//
//  Created by aibaranchikov on 08.04.2024.
//

import CoreData

protocol ExerciseDataManagerProtocol {
    
    func createAction(for: ExerciseEntity, in context: NSManagedObjectContext) -> ExerciseActionEntity
    func createRestTimeBetweenActions(for: ExerciseEntity, with duration: Int, in context: NSManagedObjectContext) -> RestActionEntity
    
    func fetchExercise(exercise: ExerciseEntity, in context: NSManagedObjectContext) -> ExerciseEntity?
    func fetchExercise(by uuid: UUID, in context: NSManagedObjectContext) -> ExerciseEntity?
    func fetchActions(for exercise: ExerciseEntity, in context: NSManagedObjectContext) -> [ExerciseActionEntity]
    func fetchRestTimeBetweenActions(for exercise: ExerciseEntity, in context: NSManagedObjectContext) -> RestActionEntity?
    
    func calculateNewActionPosition(for exercise: ExerciseEntity, in context: NSManagedObjectContext) -> Int16
    
    func setupActionPositions(for exercise: ExerciseEntity, in context: NSManagedObjectContext)
}
