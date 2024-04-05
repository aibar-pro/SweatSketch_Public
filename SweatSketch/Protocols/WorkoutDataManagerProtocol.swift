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
    func createDefaultWorkout(position: Int16, in context: NSManagedObjectContext) -> WorkoutEntity
}
