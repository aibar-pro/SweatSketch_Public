//
//  WorkoutCatalogWorkoutMoveViewModel.swift
//  SweatSketch
//
//  Created by aibaranchikov on 09.04.2024.
//

import CoreData

class WorkoutCatalogWorkoutMoveViewModel: ObservableObject {
    
    private let mainContext: NSManagedObjectContext
    private let parentViewModel: WorkoutCatalogViewModel
    var movingWorkout: WorkoutCatalogWorkoutViewRepresentation
    var collections = [WorkoutCatalogCollectionViewRepresentation]()
    
    private let collectionDataManager = CollectionDataManager()
    private let workoutDataManager = WorkoutDataManager()
    
    init(parentViewModel: WorkoutCatalogViewModel, movingWorkout: WorkoutCatalogWorkoutViewRepresentation) {
        self.mainContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        self.mainContext.parent = parentViewModel.mainContext
        
        self.parentViewModel = parentViewModel
        
        self.movingWorkout = movingWorkout
        
        let fetchedRootCollections = collectionDataManager.fetchRootCollections(in: self.mainContext, excludingTypes: [.defaultCollection, .imported])
        self.collections = fetchedRootCollections.compactMap({ $0.toWorkoutCollectionRepresentation(includeWorkouts: false)})
    }
    
    func moveWorkout(to collection: WorkoutCatalogCollectionViewRepresentation) {
        if let fetchedWorkout = workoutDataManager.fetchWorkout(by: movingWorkout.id, in: mainContext), let fetchedCollection = collectionDataManager.fetchCollection(by: collection.id, in: mainContext) {
            fetchedWorkout.collection = fetchedCollection
        }
        saveContext()
    }
    
    func saveContext() {
        do {
            try mainContext.save()
            parentViewModel.saveContext()
            parentViewModel.refreshData()
        } catch {
            print("Error saving workout move context: \(error)")
        }
    }
    
    func discardMove() {
        mainContext.rollback()
    }
}
