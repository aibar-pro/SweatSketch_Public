//
//  CollectionDataManagerProtocol.swift
//  SweatSketch
//
//  Created by aibaranchikov on 08.04.2024.
//

import CoreData

protocol CollectionDataManagerProtocol {
    func fetchCollection(by uuid: UUID, in context: NSManagedObjectContext) -> WorkoutCollectionEntity?
    func fetchFirstUserCollection(in context: NSManagedObjectContext) -> WorkoutCollectionEntity?
    func fetchCollection(collection: WorkoutCollectionEntity, in context: NSManagedObjectContext) -> WorkoutCollectionEntity?
    func fetchRootCollections(in context: NSManagedObjectContext, excludingTypes excludedTypes: [WorkoutCollectionType]) -> [WorkoutCollectionEntity]
    func fetchSubCollections(for collection: WorkoutCollectionEntity, in context: NSManagedObjectContext) -> [WorkoutCollectionEntity]
    func fetchWorkouts(for collection: WorkoutCollectionEntity, in context: NSManagedObjectContext) -> [WorkoutEntity]
    func fetchWorkoutsWithoutCollection(in context: NSManagedObjectContext) -> [WorkoutEntity]
    func fetchSystemCollection(ofType: WorkoutCollectionType, in context: NSManagedObjectContext) -> WorkoutCollectionEntity?
    
    func createCollection(with name: String?, in context: NSManagedObjectContext) -> WorkoutCollectionEntity
    func createDefaultCollection(in context: NSManagedObjectContext) -> WorkoutCollectionEntity
    func createWorkout(for collection: WorkoutCollectionEntity, in context: NSManagedObjectContext) -> WorkoutEntity
    
    func setupCollectionCatalog(in context: NSManagedObjectContext)
    
    func calculateNewCollectionPosition(ofType: WorkoutCollectionType, in context: NSManagedObjectContext) -> Int16
    func calculateNewWorkoutPosition(for collection: WorkoutCollectionEntity, in context: NSManagedObjectContext) -> Int16
}
