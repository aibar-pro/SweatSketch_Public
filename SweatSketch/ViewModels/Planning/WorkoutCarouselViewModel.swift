//
//  WorkoutPlanViewModel.swift
//  MyWorkoutPlanner
//
//  Created by aibaranchikov on 28.11.2023.
//

import Foundation
import CoreData

class WorkoutCarouselViewModel: ObservableObject {
    
    let mainContext: NSManagedObjectContext
    var workoutCollection: WorkoutCollectionEntity
    @Published var workouts = [WorkoutEntity]()
    
    private let collectionDataManager = CollectionDataManager()
    
    init(context: NSManagedObjectContext, collectionUUID: UUID? = nil) {
        self.mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.mainContext.parent = context
        
        self.workoutCollection = WorkoutCollectionEntity()
        self.workoutCollection = setupCollection(collectionUUID: collectionUUID)
        
        DispatchQueue.main.async { [weak self] in
            self?.refreshData()
        }

        if WorkoutCollectionType.from(rawValue: self.workoutCollection.type) == .defaultCollection {
            print("Default Collection Presented")
            let backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            backgroundContext.parent = mainContext
            backgroundContext.perform {
                let unassignedWorkouts = self.collectionDataManager.fetchWorkoutsWithoutCollection(in: backgroundContext)
                
                if let defaultCollectionToUpdate = self.collectionDataManager.fetchCollection(collection: self.workoutCollection, in: backgroundContext) {
                    self.assignWorkoutsToDefaultCollection(workouts: unassignedWorkouts, defaultCollection: defaultCollectionToUpdate)
                    do {
                        if backgroundContext.hasChanges {
                            try backgroundContext.save()
                            
                            DispatchQueue.main.async { [weak self] in
                                self?.saveContext()
                                self?.refreshData()
                            }
                        }
                    } catch {
                        print("Error saving in background context: \(error)")
                    }
                }
            }
        }
    }
    
    private func setupCollection(collectionUUID: UUID? = nil) -> WorkoutCollectionEntity {
        if let uuid = collectionUUID, let collection = collectionDataManager.fetchCollection(by: uuid, in: self.mainContext) {
            return collection
        } else if let collection = collectionDataManager.fetchFirstCollection(in: self.mainContext) {
            return collection
        } 
        else {
            return createDefaultCollection()
        }
    }
    
    private func createDefaultCollection() -> WorkoutCollectionEntity {
        let newCollection = WorkoutCollectionEntity(context: self.mainContext)
        newCollection.uuid = UUID()
        newCollection.name = Constants.Design.Placeholders.noCollectionName
        newCollection.type = WorkoutCollectionType.defaultCollection.rawValue
        newCollection.position = 0
        
        return newCollection
    }
    
    func assignWorkoutsToDefaultCollection(workouts: [WorkoutEntity], defaultCollection: WorkoutCollectionEntity) {
        for workout in workouts {
            workout.collection = defaultCollection
        }
    }

    func refreshData() {
        workouts = collectionDataManager.fetchWorkouts(for: workoutCollection, in: mainContext)
    }
    
    func saveContext() {
        do {
            try mainContext.save()
            try mainContext.parent?.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

}

