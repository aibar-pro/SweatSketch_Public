//
//  WorkoutCollectionViewModel.swift
//  SweatSketch
//
//  Created by aibaranchikov on 05.04.2024.
//

import CoreData

class WorkoutCollectionViewModel: ObservableObject {
    
    let mainContext: NSManagedObjectContext
    
    @Published var collections = [WorkoutCollectionRepresentation]()
    
    private let collectionDataManager = CollectionDataManager()
    
    init(context: NSManagedObjectContext) {
        self.mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.mainContext.parent = context
        
        let fetchedRootCollections = collectionDataManager.fetchNonSystemCollectionsWithoutParent(in: self.mainContext)
        self.collections = fetchedRootCollections.compactMap { transform(collectionEntity: $0) }
        
        let backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        backgroundContext.parent = self.mainContext
        backgroundContext.perform {
            self.collectionDataManager.setupCollectionCatalog(in: backgroundContext)
            do {
                if backgroundContext.hasChanges {
                    try backgroundContext.save()
                    print("Setting up default collection")
                    DispatchQueue.main.async { [weak self] in
                        do {
                            try self?.mainContext.save()
                            try self?.mainContext.parent?.save()
                        } catch {
                            print("Error saving main context in background context: \(error)")
                        }
                        self?.refreshData()
                    }
                }
            } catch {
                print("Error saving in background context: \(error)")
            }
        }
    }
    
    func refreshData() {
        let fetchedRootCollections = collectionDataManager.fetchCollectionsWithoutParent(in: self.mainContext)
        self.collections = fetchedRootCollections.compactMap { transform(collectionEntity: $0) }
    }
    
    private func transform(collectionEntity: WorkoutCollectionEntity) -> WorkoutCollectionRepresentation? {
        guard let id = collectionEntity.uuid else { return nil }
        
        let workouts = collectionDataManager.fetchWorkouts(for: collectionEntity, in: self.mainContext)
        
        let fetchedSubCollections = collectionDataManager.fetchSubCollections(for: collectionEntity, in: self.mainContext)
        let subCollections = fetchedSubCollections.compactMap {
            transform(collectionEntity: $0)
        }
        
        return WorkoutCollectionRepresentation(
            id: id,
            name: (collectionEntity.name ?? "Unnamed Collection") + ": \(collectionEntity.position)",
            subCollections: subCollections,
            workouts: workouts
        )
    }
}
