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
    func fetchDefaultRestTime(for workout: WorkoutEntity, in context: NSManagedObjectContext) -> RestTimeEntity?
    
    func createExercise(for workout: WorkoutEntity, in context: NSManagedObjectContext) -> ExerciseEntity
    func createDefaultRestTime(for workout: WorkoutEntity, with duration: Int, in context: NSManagedObjectContext) -> RestTimeEntity
    
    func calculateNewExercisePosition(for workout: WorkoutEntity, in context: NSManagedObjectContext) -> Int16
    
    func setupExercisePositions(for workout: WorkoutEntity, in context: NSManagedObjectContext)
    
    func createRestTime(for followingExercise: ExerciseEntity, with duration: Int, in context: NSManagedObjectContext) -> RestTimeEntity
    func fetchRestTime(for followingExercise: ExerciseEntity, in context: NSManagedObjectContext) -> RestTimeEntity?
}
