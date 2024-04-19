//
//  WorkoutPlanViewModel.swift
//  MyWorkoutPlanner
//
//  Created by aibaranchikov on 28.11.2023.
//

import CoreData

class WorkoutCarouselViewModel: ObservableObject {
    
    let mainContext: NSManagedObjectContext
    var workoutCollection: WorkoutCollectionEntity
    
    @Published var workouts = [WorkoutViewRepresentation]()
    
    private let collectionDataManager = CollectionDataManager()
    
    init(context: NSManagedObjectContext, collectionUUID: UUID? = nil) {
        self.mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.mainContext.parent = context
        
        self.workoutCollection = WorkoutCollectionEntity()
        self.workoutCollection = setupCollection(collectionUUID: collectionUUID)
        
        
        refreshData()
        

//        if WorkoutCollectionType.from(rawValue: self.workoutCollection.type) == .defaultCollection {
//            print("Default Collection Presented")
//            let backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
//            backgroundContext.parent = mainContext
//            backgroundContext.perform {
//                self.collectionDataManager.setupDefaultCollection(in: backgroundContext)
//                do {
//                    if backgroundContext.hasChanges {
//                        try backgroundContext.save()
//                        
//                        DispatchQueue.main.async { [weak self] in
//                            self?.saveContext()
//                            self?.refreshData()
//                        }
//                    }
//                } catch {
//                    print("Error saving in background context: \(error)")
//                }
//            }
//        }
    }
    
    private func setupCollection(collectionUUID: UUID? = nil) -> WorkoutCollectionEntity {
        if let uuid = collectionUUID, let collection = collectionDataManager.fetchCollection(by: uuid, in: self.mainContext) {
            return collection
        } else if let collection = collectionDataManager.fetchFirstUserCollection(in: self.mainContext) {
            return collection
        } 
        else if let fetchedDefaultCollection = collectionDataManager.fetchSystemCollection(ofType: .defaultCollection, in: self.mainContext){
            return fetchedDefaultCollection
        } else {
            let newDefaultCollection = collectionDataManager.createDefaultCollection(in: self.mainContext)
            print("CREATED DEFAULT COLLECTION")
            self.saveContext()
            return newDefaultCollection
        }
    }
    
    func assignWorkoutsToDefaultCollection(workouts: [WorkoutEntity], defaultCollection: WorkoutCollectionEntity) {
        for workout in workouts {
            workout.collection = defaultCollection
        }
    }

    func refreshData() {
        DispatchQueue.main.async { [weak self] in
            if let context = self?.mainContext, let collection = self?.workoutCollection, let fetchedWorkouts = self?.collectionDataManager.fetchWorkouts(for: collection, in: context) {
                self?.workouts = fetchedWorkouts.compactMap({ $0.toWorkoutViewRepresentation() })
            }
        }
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

