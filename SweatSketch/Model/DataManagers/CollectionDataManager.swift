//
//  CollectionDataManager.swift
//  SweatSketch
//
//  Created by aibaranchikov on 08.04.2024.
//

import CoreData

class CollectionDataManager: CollectionDataManagerProtocol {
    func fetchCollection(by uuid: UUID, in context: NSManagedObjectContext) -> WorkoutCollectionEntity? {
        let fetchRequest: NSFetchRequest<WorkoutCollectionEntity> = WorkoutCollectionEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uuid = %@", uuid as CVarArg)
        fetchRequest.fetchLimit = 1
        
        do {
            let collectionToReturn = try context.fetch(fetchRequest).first
            return collectionToReturn
        } catch {
            print("Error fetching collection by UUID: \(error)")
            return nil
        }
    }
    
    func fetchFirstCollection(in context: NSManagedObjectContext) -> WorkoutCollectionEntity? {
        let fetchRequest: NSFetchRequest<WorkoutCollectionEntity> = WorkoutCollectionEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "position", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchLimit = 1
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch {
            print("Error fetching first collection: \(error)")
            return nil
        }
    }
    
    func fetchCollection(collection: WorkoutCollectionEntity, in context: NSManagedObjectContext) -> WorkoutCollectionEntity? {
        let fetchRequest: NSFetchRequest<WorkoutCollectionEntity> = WorkoutCollectionEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "SELF == %@", collection.objectID)
        fetchRequest.fetchLimit = 1
        
        do {
            let collectionToReturn = try context.fetch(fetchRequest).first
            return collectionToReturn
        } catch {
            print("Error fetching collection in context: \(error)")
            return nil
        }
    }
    
    func fetchWorkouts(for collection: WorkoutCollectionEntity, in context: NSManagedObjectContext) -> [WorkoutEntity] {
        let fetchRequest: NSFetchRequest<WorkoutEntity> = WorkoutEntity.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "position", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchRequest.predicate = NSPredicate(format: "collection == %@", collection)

        do {
            let workoutsToReturn = try context.fetch(fetchRequest)
            return workoutsToReturn
        } catch {
            print("Error fetching workouts for collection \(String(describing: collection.uuid)): \(error)")
            return []
        }
    }
    
    func fetchWorkoutsWithoutCollection(in context: NSManagedObjectContext) -> [WorkoutEntity] {
        let fetchRequest: NSFetchRequest<WorkoutEntity> = WorkoutEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "collection == nil")
        
        do {
            let workoutsWithoutCollection = try context.fetch(fetchRequest)
            return workoutsWithoutCollection
        } catch {
            print("Error fetching workouts without a collection: \(error)")
            return []
        }
    }
}
