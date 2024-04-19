//
//  WorkoutCollectionViewModel.swift
//  SweatSketch
//
//  Created by aibaranchikov on 05.04.2024.
//

import CoreData

class WorkoutCollectionViewModel: ObservableObject {
    
    let mainContext: NSManagedObjectContext
    
    @Published var collections = [WorkoutCollectionViewRepresentation]()
    
    private let collectionDataManager = CollectionDataManager()
    
    init(context: NSManagedObjectContext) {
        self.mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.mainContext.parent = context
        
        refreshData()
        
        setupWorkoutCatalog()
    }
    
    func addCollection(with name: String) {
        let _ = collectionDataManager.createCollection(with: name, in: mainContext)
        setupWorkoutCatalog()
    }
    
    private func setupWorkoutCatalog() {
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
        DispatchQueue.main.async { [weak self] in
            if let context = self?.mainContext, let fetchedRootCollections = self?.collectionDataManager.fetchRootCollections(in: context) {
                self?.collections = fetchedRootCollections.compactMap { $0.toWorkoutCollectionRepresentation() }
            }
        }
    }
    
    func saveContext() {
        do {
            try mainContext.save()
            try mainContext.parent?.save()
        } catch {
            print("Error saving workout move context: \(error)")
        }
    }

}
