//
//  WorkoutCollectionViewModel.swift
//  MyWorkoutPlanner
//
//  Created by aibaranchikov on 28.11.2023.
//

import CoreData

class WorkoutCollectionViewModel: ObservableObject {
    
    let context: NSManagedObjectContext
    var workoutCollection: WorkoutCollectionEntity
    
    @Published private(set) var workouts = [WorkoutRepresentation]()
    
    private let collectionDataManager = CollectionDataManager()
    
    init(context: NSManagedObjectContext, collectionUUID: UUID? = nil) {
        self.context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.context.parent = context
        
        self.workoutCollection = WorkoutCollectionEntity()
        self.workoutCollection = fetchCollection(with: collectionUUID)
        
        refreshData()
    }
    
    private func fetchCollection(with collectionUuid: UUID? = nil) -> WorkoutCollectionEntity {
        if let collectionUuid,
            let collection = collectionDataManager.fetchCollection(by: collectionUuid, in: self.context) {
            print("\(type(of: self)): Fetched collection with UUID: \(collectionUuid)")
            return collection
        }
        
        if let collection = collectionDataManager.fetchFirstUserCollection(in: self.context) {
            print("\(type(of: self)): Fetched first user collection")
            return collection
        }
        
        if let fetchedDefaultCollection = collectionDataManager.fetchSystemCollection(ofType: .defaultCollection, in: self.context) {
            print("\(type(of: self)): Fetched default collection")
            return fetchedDefaultCollection
        }
        
        let newDefaultCollection = collectionDataManager.createDefaultCollection(in: self.context)
        self.saveContext()
        print("\(type(of: self)): Default collection created")
        return newDefaultCollection
    }

    func refreshData() {
        let fetchedWorkouts = collectionDataManager.fetchWorkouts(for: workoutCollection, in: context)
        print("\(type(of: self)): Fetched \(fetchedWorkouts.count) workouts")
        DispatchQueue.main.async { [weak self] in
            self?.workouts = fetchedWorkouts.compactMap { $0.toWorkoutRepresentation() }
        }
    }
    
    func saveContext() {
        do {
            try context.save()
            try context.parent?.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
