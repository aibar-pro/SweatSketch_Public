//
//  WorkoutCollectionEditViewModel.swift
//  SweatSketch
//
//  Created by aibaranchikov on 09.04.2024.
//

import CoreData

class WorkoutCollectionEditViewModel: ObservableObject {
    
    private let mainContext: NSManagedObjectContext
    private let parentViewModel: WorkoutCollectionViewModel
    @Published var editingCollection: WorkoutCollectionEntity
    
    private let collectionDataManager = CollectionDataManager()
    
    init(parentViewModel: WorkoutCollectionViewModel, editingCollectionUUID: UUID? = nil, parentCollection: UUID? = nil) {
        self.mainContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        self.mainContext.parent = parentViewModel.mainContext
        
        self.parentViewModel = parentViewModel
        
        self.editingCollection = WorkoutCollectionEntity()
        
        if let collectionUUID = editingCollectionUUID, let fetchedCollection = collectionDataManager.fetchCollection(by: collectionUUID, in: self.mainContext) {
            self.editingCollection = fetchedCollection
        } else {
            self.editingCollection = collectionDataManager.createCollection(in: self.mainContext)
        }
    }
    
    func saveCollection() {
        do {
            try mainContext.save()
            try mainContext.parent?.save()
            parentViewModel.refreshData()
        } catch {
            print("Error saving workout context: \(error)")
        }
    }
    
    func discardCollection() {
        mainContext.rollback()
    }
}
