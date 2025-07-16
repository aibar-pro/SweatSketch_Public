//
//  WorkoutDataManagerProtocol.swift
//  SweatSketch
//
//  Created by aibaranchikov on 08.04.2024.
//

import CoreData

protocol WorkoutDataManagerProtocol {
    func fetchWorkout(workout: WorkoutEntity, in context: NSManagedObjectContext) -> WorkoutEntity?
    func fetchWorkout(by uuid: UUID, in context: NSManagedObjectContext) -> WorkoutEntity?
    func fetchExercises(for workout: WorkoutEntity, in context: NSManagedObjectContext) -> [ExerciseEntity]
    
    func createExercise(for workout: WorkoutEntity, in context: NSManagedObjectContext) -> ExerciseEntity
    
    func calculateNewExercisePosition(for workout: WorkoutEntity, in context: NSManagedObjectContext) -> Int16
    
    func reindexExercises(for workout: WorkoutEntity, in context: NSManagedObjectContext)
}
