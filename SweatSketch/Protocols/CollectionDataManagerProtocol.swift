//
//  CollectionDataManagerProtocol.swift
//  SweatSketch
//
//  Created by aibaranchikov on 08.04.2024.
//

import CoreData

protocol CollectionDataManagerProtocol {
    func fetchCollection(by uuid: UUID, in context: NSManagedObjectContext) -> WorkoutCollectionEntity?
    func fetchFirstCollection(in context: NSManagedObjectContext) -> WorkoutCollectionEntity?
    func fetchCollection(collection: WorkoutCollectionEntity, in context: NSManagedObjectContext) -> WorkoutCollectionEntity?
    func fetchWorkouts(for collection: WorkoutCollectionEntity, in context: NSManagedObjectContext) -> [WorkoutEntity]
    func fetchWorkoutsWithoutCollection(in context: NSManagedObjectContext) -> [WorkoutEntity]
}
