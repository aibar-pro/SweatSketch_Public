//
//  WorkoutCatalogCollectionMergeViewModel.swift
//  SweatSketch
//
//  Created by aibaranchikov on 13.04.2024.
//

import CoreData

class WorkoutCatalogCollectionMergeViewModel: ObservableObject {
    
    private let mainContext: NSManagedObjectContext
    private let parentViewModel: WorkoutCatalogViewModel
    var sourceCollection: CollectionRepresentation
    var collections = [CollectionRepresentation]()
    
    private let collectionDataManager = CollectionDataManager()
    
    init(parentViewModel: WorkoutCatalogViewModel, sourceCollection: CollectionRepresentation) {
        self.mainContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        self.mainContext.parent = parentViewModel.mainContext
        
        self.parentViewModel = parentViewModel
        
        self.sourceCollection = sourceCollection
        
        let fetchedRootCollections = collectionDataManager.fetchRootCollections(in: self.mainContext, excludingTypes: [.defaultCollection, .imported])
        self.collections = fetchedRootCollections.compactMap({ $0.toWorkoutCollectionRepresentation(includeWorkouts: false) })
    }
    
    func mergeCollections(to targetCollection: CollectionRepresentation) {
        if let fetchedTargetCollection = collectionDataManager.fetchCollection(by: targetCollection.id, in: mainContext),
           let fetchedSourceCollection = collectionDataManager.fetchCollection(by: sourceCollection.id, in: mainContext)
        {
            let fetchedWorkouts = collectionDataManager.fetchWorkouts(for: fetchedSourceCollection, in: mainContext)
            fetchedWorkouts.forEach({ $0.collection = fetchedTargetCollection })
            if fetchedSourceCollection.subCollections?.count == 0 {
                mainContext.delete(fetchedSourceCollection)
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
            print("Error saving collection merge context: \(error)")
        }
    }
    
    func discardMerge() {
        mainContext.rollback()
    }
}
