//
//  WorkoutCollectionViewModel.swift
//  SweatSketch
//
//  Created by aibaranchikov on 05.04.2024.
//

import CoreData

class WorkoutCollectionViewModel: ObservableObject {
    
    let collectionContext: NSManagedObjectContext
    
    @Published var collections = [WorkoutCollectionRepresentation]()
    
    init(context: NSManagedObjectContext) {
        self.collectionContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.collectionContext.parent = context
        
        let collectionFetchRequest: NSFetchRequest<WorkoutCollectionEntity> = WorkoutCollectionEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "position", ascending: true)
        collectionFetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let result = try context.fetch(collectionFetchRequest)
            self.collections = result.compactMap { transform(collectionEntity: $0) }
        } catch {
            print("Error fetching collections: \(error)")
        }
    }
    
    private func transform(collectionEntity: WorkoutCollectionEntity) -> WorkoutCollectionRepresentation? {
        guard let id = collectionEntity.uuid else { return nil }
        
        let workouts = collectionEntity.workouts?.array as? [WorkoutEntity] ?? []
//        
//        let workouts = ((collectionEntity.workouts?.array as? [WorkoutEntity])?.compactMap { workoutEntity in
//            guard let workoutId = workoutEntity.uuid else { return nil }
//            return WorkoutCollectionWorkoutRepresentation(id: workoutId, name: workoutEntity.name ?? Constants.Design.Placeholders.noWorkoutName)
//        } ?? []) as [WorkoutCollectionWorkoutRepresentation]
        
        let subCollections = (collectionEntity.subCollections?.array as? [WorkoutCollectionEntity])?.compactMap {
            transform(collectionEntity: $0)
        } ?? []
        
        return WorkoutCollectionRepresentation(
            id: id,
            name: collectionEntity.name ?? "Unnamed Collection",
            subCollections: subCollections,
            workouts: workouts
        )
    }
}
