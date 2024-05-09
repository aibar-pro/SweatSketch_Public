//
//  WorkoutCatalogCollectionViewRepresentation.swift
//  SweatSketch
//
//  Created by aibaranchikov on 06.04.2024.
//

import CoreData

class WorkoutCatalogCollectionViewRepresentation: Identifiable, Equatable, ObservableObject {
    static func == (lhs: WorkoutCatalogCollectionViewRepresentation, rhs: WorkoutCatalogCollectionViewRepresentation) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.subCollections == rhs.subCollections &&
            lhs.workouts == rhs.workouts
    }
    
    let id: UUID
    var name: String = ""
    var subCollections = [WorkoutCatalogCollectionViewRepresentation]()
    var workouts = [WorkoutCatalogWorkoutViewRepresentation]()
    
    private let collectionDataManager = CollectionDataManager()
    
    init?(collection: WorkoutCollectionEntity, in context: NSManagedObjectContext, includeSubCollections: Bool = true, includeWorkouts: Bool = true) {
        guard let id = collection.uuid else { return nil }
        self.id = id
        switch WorkoutCollectionType.from(rawValue: collection.type) {
        case .defaultCollection:
            self.name = collection.name ?? Constants.DefaultValues.defaultWorkoutCollectionName
        case .imported:
            self.name = collection.name ?? Constants.DefaultValues.importedWorkoutCollectionName
        default:
            self.name = collection.name ?? Constants.Placeholders.noCollectionName
        }
        
        if includeSubCollections {
            fetchSubCollections(collection, context)
        }
        
        if includeWorkouts {
            fetchWorkouts(collection, context)
        }
    }
    
    private func fetchWorkouts(_ collection: WorkoutCollectionEntity, _ context: NSManagedObjectContext) {
        let fetchedWorkouts = collectionDataManager.fetchWorkouts(for: collection, in: context)
        self.workouts = fetchedWorkouts.compactMap({ $0.toWorkoutCollectionWorkoutRepresentation() })
    }
    
    private func fetchSubCollections(_ collection: WorkoutCollectionEntity, _ context: NSManagedObjectContext) {
        let fetchedSubCollections = collectionDataManager.fetchSubCollections(for: collection, in: context)
        self.subCollections = fetchedSubCollections.compactMap({ $0.toWorkoutCollectionRepresentation() })
    }
}

extension WorkoutCollectionEntity {
    func toWorkoutCollectionRepresentation(includeSubCollections: Bool = true, includeWorkouts: Bool = true) -> WorkoutCatalogCollectionViewRepresentation? {
        guard let context = self.managedObjectContext else {
            return nil
        }
        return WorkoutCatalogCollectionViewRepresentation(collection: self, in: context, includeSubCollections: includeSubCollections, includeWorkouts: includeWorkouts)
    }
}
