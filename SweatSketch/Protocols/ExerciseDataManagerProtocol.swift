//
//  ExerciseDataManagerProtocol.swift
//  SweatSketch
//
//  Created by aibaranchikov on 08.04.2024.
//

import CoreData

protocol ExerciseDataManagerProtocol {
    func createDefaultExercise(position: Int16, in context: NSManagedObjectContext) -> ExerciseEntity
    func createDefaultRestTimeBetweenActions(for duration: Int?, in context: NSManagedObjectContext) -> ExerciseActionEntity
    func fetchExercise(exercise: ExerciseEntity, in context: NSManagedObjectContext) -> ExerciseEntity?
    func fetchActions(for exercise: ExerciseEntity, in context: NSManagedObjectContext) -> [ExerciseActionEntity]
    func fetchRestTimeBetweenActions(for exercise: ExerciseEntity, in context: NSManagedObjectContext) -> ExerciseActionEntity?
}
