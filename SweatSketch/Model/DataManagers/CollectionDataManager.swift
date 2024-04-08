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
    
    func fetchCollectionsWithoutParent(in context: NSManagedObjectContext) -> [WorkoutCollectionEntity] {
        let fetchRequest: NSFetchRequest<WorkoutCollectionEntity> = WorkoutCollectionEntity.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "parentCollection == nil")
        
        let sortDescriptor = NSSortDescriptor(key: "position", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let collectionsToReturn = try context.fetch(fetchRequest)
            return collectionsToReturn
        } catch {
            print("Error fetching collections: \(error)")
            return []
        }
    }
    func fetchNonSystemCollectionsWithoutParent(in context: NSManagedObjectContext) -> [WorkoutCollectionEntity] {
        let fetchRequest: NSFetchRequest<WorkoutCollectionEntity> = WorkoutCollectionEntity.fetchRequest()

        let withoutParentPredicate = NSPredicate(format: "parentCollection == nil")
        let notDefaultPredicate = NSPredicate(format: "type != %@", WorkoutCollectionType.defaultCollection.rawValue)
        let notImportedPredicate = NSPredicate(format: "type != %@", WorkoutCollectionType.imported.rawValue)
        let noTypePredicate = NSPredicate(format: "type == nil")
        
        let systemTypePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [notDefaultPredicate, notImportedPredicate])
        let typePrecicate = NSCompoundPredicate(orPredicateWithSubpredicates: [noTypePredicate, systemTypePredicate])
        
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [withoutParentPredicate, typePrecicate])
        
        let sortDescriptor = NSSortDescriptor(key: "position", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        do {
            let collectionsToReturn = try context.fetch(fetchRequest)
            return collectionsToReturn
        } catch {
            print("Error fetching collections: \(error)")
            return []
        }
    }
    
    func fetchFirstUserCollection(in context: NSManagedObjectContext) -> WorkoutCollectionEntity? {
        let fetchRequest: NSFetchRequest<WorkoutCollectionEntity> = WorkoutCollectionEntity.fetchRequest()
        
        let userTypePredicate = NSPredicate(format: "type == %@", WorkoutCollectionType.user.rawValue)
        let nilTypePredicate = NSPredicate(format: "type == nil")
        let typePredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [userTypePredicate, nilTypePredicate])
        
        let workoutsNotEmptyPredicate = NSPredicate(format: "workouts.@count > 0")
        
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [typePredicate, workoutsNotEmptyPredicate])
        
        let sortDescriptor = NSSortDescriptor(key: "position", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchRequest.fetchLimit = 1
        
        do {
            let collectionToReturn = try context.fetch(fetchRequest).first
            return collectionToReturn
        } catch {
            print("Error fetching first collection: \(error)")
            return nil
        }
    }
    
    func fetchSubCollections(for collection: WorkoutCollectionEntity, in context: NSManagedObjectContext) -> [WorkoutCollectionEntity] {
        let fetchRequest: NSFetchRequest<WorkoutCollectionEntity> = WorkoutCollectionEntity.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "parentCollection == %@", collection)
        
        let sortDescriptor = NSSortDescriptor(key: "position", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let collectionsToReturn = try context.fetch(fetchRequest)
            return collectionsToReturn
        } catch {
            print("Error fetching subCollections: \(error)")
            return []
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
    
    func fetchSystemCollection(ofType: WorkoutCollectionType, in context: NSManagedObjectContext) -> WorkoutCollectionEntity? {
        let fetchRequest: NSFetchRequest<WorkoutCollectionEntity> = WorkoutCollectionEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "type == %@", ofType.rawValue)
        fetchRequest.fetchLimit = 1
        
        do {
            let collectionToReturn = try context.fetch(fetchRequest).first
            return collectionToReturn
        } catch {
            print("Error fetching collection in context: \(error)")
            return nil
        }
    }
    
    func createDefaultCollection(in context: NSManagedObjectContext) -> WorkoutCollectionEntity {
        let newCollection = WorkoutCollectionEntity(context: context)
        newCollection.uuid = UUID()
        newCollection.name = Constants.DefaultValues.defaultWorkoutCollectionName
        newCollection.type = WorkoutCollectionType.defaultCollection.rawValue
        newCollection.position = calculateNewCollectionPosition(ofType: .defaultCollection, in: context)
        
        return newCollection
    }
    
    func createCollection(in context: NSManagedObjectContext) -> WorkoutCollectionEntity {
        let newCollection = WorkoutCollectionEntity(context: context)
        newCollection.uuid = UUID()
        newCollection.name = Constants.Placeholders.noCollectionName
        newCollection.type = WorkoutCollectionType.user.rawValue
        newCollection.position = calculateNewCollectionPosition(ofType: .user, in: context)
        
        return newCollection
    }
    
    func createWorkout(for collection: WorkoutCollectionEntity, in context: NSManagedObjectContext) -> WorkoutEntity {
        let newWorkout = WorkoutEntity(context: context)
        newWorkout.uuid = UUID()
        newWorkout.name = Constants.Placeholders.noWorkoutName
        newWorkout.position = calculateNewWorkoutPosition(for: collection, in: context)
        newWorkout.collection = fetchCollection(collection: collection, in: context)
        
        return newWorkout
    }
    
    func setupCollectionCatalog(in context: NSManagedObjectContext) {
        var defaultCollectionToSetup = WorkoutCollectionEntity()
        
        if let defaultCollection = self.fetchSystemCollection(ofType: .defaultCollection, in: context) {
            print("Setup Default Collection: FETCHED \(WorkoutCollectionType.from(rawValue: defaultCollection.type))")
            defaultCollectionToSetup = defaultCollection
        } else {
            print("Setup Default Collection: CREATE")
            defaultCollectionToSetup = self.createDefaultCollection(in: context)
        }
        
        let workoutsWithoutCollection = self.fetchWorkoutsWithoutCollection(in: context)
        
        for workout in workoutsWithoutCollection {
            workout.collection = defaultCollectionToSetup
        }
        print("Setup Default Collection: WORKOUTS ASSIGNED \(workoutsWithoutCollection.count)")
        
        let rootCollections = self.fetchNonSystemCollectionsWithoutParent(in: context)
        for (index, collection) in rootCollections.enumerated() {
            collection.position = Int16(index)
        }
        
        defaultCollectionToSetup.position = Int16(rootCollections.count)
        print("Setup Default Collection: ADJUSTED POSITION \(defaultCollectionToSetup.position)")
        
        if let importedCollection = fetchSystemCollection(ofType: .imported, in: context) {
            importedCollection.position = Int16(rootCollections.count + 1)
            print("Setup Imported Collection: ADJUSTED POSITION")
        }
    }
    
    func calculateNewCollectionPosition(ofType: WorkoutCollectionType, in context: NSManagedObjectContext) -> Int16 {
        let rootCollections = fetchNonSystemCollectionsWithoutParent(in: context)
        
        print(rootCollections.count)
        switch ofType {
        case .imported:
            return Int16(rootCollections.count+1)
        case .defaultCollection:
            return Int16(rootCollections.count)
        default:
            return Int16(max(rootCollections.count - 1, 0))
        }
    }
    
    func calculateNewWorkoutPosition(for collection: WorkoutCollectionEntity, in context: NSManagedObjectContext) -> Int16 {
        let workoutCount = fetchWorkouts(for: collection, in: context).count
        return Int16(workoutCount)
    }
}
