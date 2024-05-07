//
//  WorkoutCatalogCollectionMoveViewModel.swift
//  SweatSketch
//
//  Created by aibaranchikov on 13.04.2024.
//

import CoreData

class WorkoutCatalogCollectionMoveViewModel: ObservableObject {
    
    private let mainContext: NSManagedObjectContext
    private let parentViewModel: WorkoutCatalogViewModel
    var movingCollection: WorkoutCollectionViewRepresentation
    var collections = [WorkoutCollectionViewRepresentation]()
    
    private let collectionDataManager = CollectionDataManager()
    
    init(parentViewModel: WorkoutCatalogViewModel, movingCollection: WorkoutCollectionViewRepresentation) {
        self.mainContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        self.mainContext.parent = parentViewModel.mainContext
        
        self.parentViewModel = parentViewModel
        
        self.movingCollection = movingCollection
        
        let fetchedRootCollections = collectionDataManager.fetchRootCollections(in: self.mainContext, excludingTypes: [.defaultCollection, .imported])
        self.collections = fetchedRootCollections.compactMap({ collection in
            if collection.uuid == movingCollection.id {
                return nil
            } else {
                return collection.toWorkoutCollectionRepresentation(includeSubCollections: false, includeWorkouts: false)
            }
        })
    }
    
    func moveCollection(to parentCollection: WorkoutCollectionViewRepresentation? = nil) {
        if let fetchedCollection = collectionDataManager.fetchCollection(by: movingCollection.id, in: mainContext) {
            if let parentCollectionToFetch = parentCollection,
               let fetchedParentCollection = collectionDataManager.fetchCollection(by: parentCollectionToFetch.id, in: mainContext) {
                fetchedCollection.parentCollection = fetchedParentCollection
            } else {
                fetchedCollection.parentCollection = nil
            }
        }
        saveContext()
    }
    
    func saveContext() {
        do {
            try mainContext.save()
            parentViewModel.saveContext()
            parentViewModel.refreshData()
        } catch {
            print("Error saving collection move context: \(error)")
        }
    }
    
    func discardMove() {
        mainContext.rollback()
    }
}
