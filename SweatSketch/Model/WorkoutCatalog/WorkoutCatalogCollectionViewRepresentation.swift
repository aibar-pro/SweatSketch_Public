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
    
    init?(collection: WorkoutCollectionEntity, in context: NSManagedObjectContext, includeSubCollections: Bool = true, includeWorkouts: Bool = true) {
        guard let id = collection.uuid else { return nil }
        self.id = id
        self.name = collection.name ?? WorkoutCatalogCollectionViewRepresentation.defaultName(for: collection)
        
        let collectionDataManager = CollectionDataManager()
        
        if includeSubCollections {
            let fetchedSubCollections = collectionDataManager.fetchSubCollections(for: collection, in: context)
            subCollections = fetchedSubCollections.compactMap({ $0.toWorkoutCollectionRepresentation() })
        }
        
        if includeWorkouts {
            let fetchedWorkouts = collectionDataManager.fetchWorkouts(for: collection, in: context)
            workouts = fetchedWorkouts.compactMap({ $0.toWorkoutCollectionWorkoutRepresentation() })
        }
    }
    
    private static func defaultName(for collection: WorkoutCollectionEntity) -> String {
        switch WorkoutCollectionType.from(rawValue: collection.type) {
        case .defaultCollection:
            return Constants.DefaultValues.defaultWorkoutCollectionName
        case .imported:
            return Constants.DefaultValues.importedWorkoutCollectionName
        default:
            return Constants.Placeholders.noCollectionName
        }
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
