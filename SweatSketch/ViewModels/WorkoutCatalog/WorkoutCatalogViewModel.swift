//
//  WorkoutCatalogViewModel.swift
//  SweatSketch
//
//  Created by aibaranchikov on 05.04.2024.
//

import CoreData
import Combine

class WorkoutCatalogViewModel: ObservableObject {
    
    let mainContext: NSManagedObjectContext
    
    @Published var collections = [CollectionRepresentation]()
    @Published var isLoggedIn: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    private let collectionDataManager = CollectionDataManager()
    
    init(context: NSManagedObjectContext) {
        self.mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.mainContext.parent = context
        
        refreshData()
        
//        setupWorkoutCatalog()
        
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        UserSession.shared.$isLoggedIn
            .receive(on: DispatchQueue.main)
            .assign(to: \.isLoggedIn, on: self)
            .store(in: &cancellables)
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
                    print("\(type(of: self)): Setting up default collection")
                    self.saveContext()
                    self.refreshData()
                }
            } catch {
                print("\(type(of: self)): Error saving in background context: \(error)")
            }
        }
    }
    
    func refreshData() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            collections = collectionDataManager
                .fetchRootCollections(in: mainContext)
                .compactMap { $0.toWorkoutCollectionRepresentation() }
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
