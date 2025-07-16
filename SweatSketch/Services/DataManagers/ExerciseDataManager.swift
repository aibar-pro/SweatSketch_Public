//
//  ExerciseDataManager.swift
//  SweatSketch
//
//  Created by aibaranchikov on 08.04.2024.
//

import CoreData

final class ExerciseDataManager {
    func createRepsAction(
        for exercise: ExerciseEntity,
        from draft: ActionDraftModel,
        in context: NSManagedObjectContext
    ) -> Result<UUID, DataManagerError> {
        let action = RepsActionEntity(from: draft, in: context)
        action.uuid = UUID()
        action.position = draft.position.int16
        
        guard let id = action.uuid else {
            return .failure(
                .createError(
                    entityName: "\(type(of: RepsActionEntity.self))",
                    payload: .init(context: context)
                )
            )
        }
        
        exercise.addToExerciseActions(action)
        return .success(id)
    }
    
    func createTimedAction(for exercise: ExerciseEntity, from draft: ActionDraftModel, in context: NSManagedObjectContext) -> Result<UUID, DataManagerError> {
        let action = TimedActionEntity(from: draft, in: context)
        action.uuid = UUID()
        action.position = draft.position.int16
        
        guard let id = action.uuid else {
            return .failure(
                .createError(
                    entityName: "\(type(of: TimedActionEntity.self))",
                    payload: .init(context: context)
                )
            )
        }
        
        exercise.addToExerciseActions(action)
        return .success(id)
    }
    
    func createDistanceAction(for exercise: ExerciseEntity, from draft: ActionDraftModel, in context: NSManagedObjectContext) -> Result<UUID, DataManagerError> {
        let action = DistanceActionEntity(from: draft, in: context)
        action.uuid = UUID()
        action.position = draft.position.int16
        
        guard let id = action.uuid else {
            return .failure(
                .createError(
                    entityName: "\(type(of: DistanceActionEntity.self))",
                    payload: .init(context: context)
                )
            )
        }
        exercise.addToExerciseActions(action)
        return .success(id)
    }
    
    func updateRepsAction(
        with uuid: UUID,
        using draft: ActionDraftModel,
        in context: NSManagedObjectContext
    ) -> Result<Void, DataManagerError> {
        do {
            guard let fetchedAction = try fetchAction(with: uuid, in: context).get() as? RepsActionEntity
            else {
                throw DataManagerError.fetchError(entityName: "\(type(of: RepsActionEntity.self))", payload: .init(context: context))
            }
            
            fetchedAction.update(from: draft)
            return .success(())
        } catch {
            assertionFailure("Failed to fetch action: \(error)")
            return
                .failure(
                    .fetchError(
                        entityName: "\(type(of: RepsActionEntity.self))",
                        payload: .init(context: context, error: error)
                    )
                )
        }
    }
    
    func updateTimedAction(
        with uuid: UUID,
        using draft: ActionDraftModel,
        in context: NSManagedObjectContext
    ) -> Result<Void, DataManagerError> {
        do {
            guard let fetchedAction = try fetchAction(with: uuid, in: context).get() as? TimedActionEntity
            else {
                throw DataManagerError.fetchError(entityName: "\(type(of: TimedActionEntity.self))", payload: .init(context: context))
            }
            
            fetchedAction.update(from: draft)
            return .success(())
        } catch {
            assertionFailure("Failed to fetch action: \(error)")
            return
                .failure(
                    .fetchError(
                        entityName: "\(type(of: TimedActionEntity.self))",
                        payload: .init(context: context, error: error)
                    )
                )
        }
    }
    
    func updateDistanceAction(
        with uuid: UUID,
        using draft: ActionDraftModel,
        in context: NSManagedObjectContext
    ) -> Result<Void, DataManagerError> {
        do {
            guard let fetchedAction = try fetchAction(with: uuid, in: context).get() as? DistanceActionEntity
            else {
                throw DataManagerError.fetchError(entityName: "\(type(of: DistanceActionEntity.self))", payload: .init(context: context))
            }
            
            fetchedAction.update(from: draft)
            return .success(())
        } catch {
            assertionFailure("Failed to fetch action: \(error)")
            return
                .failure(
                    .fetchError(
                        entityName: "\(type(of: DistanceActionEntity.self))",
                        payload: .init(context: context, error: error)
                    )
                )
        }
    }
    
    func removeAction(with id: UUID, in context: NSManagedObjectContext) {
        guard let actionToDelete = try? fetchAction(with: id, in: context).get()
        else {
            assertionFailure("Could not find action with id \(id) to delete")
            return
        }
        context.delete(actionToDelete)
    }
    
    func removeExercise(with id: UUID, in context: NSManagedObjectContext) {
        guard let actionToDelete = fetchExercise(by: id, in: context)
        else {
            assertionFailure("Could not find exercise with id \(id) to delete")
            return
        }
        context.delete(actionToDelete)
    }
    
    func fetchActions(
        for exercise: ExerciseEntity,
        in context: NSManagedObjectContext
    ) -> [ExerciseActionEntity] {
        let fetchRequest: NSFetchRequest<ExerciseActionEntity> = ExerciseActionEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "exercise == %@", exercise)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "position", ascending: true)]
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching actions: \(error)")
            return []
        }
    }
    
    func fetchAction(with id: UUID, in context: NSManagedObjectContext) -> Result<ExerciseActionEntity, DataManagerError> {
        let fetchRequest: NSFetchRequest<ExerciseActionEntity> = ExerciseActionEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", id as CVarArg)
        fetchRequest.fetchLimit = 1
        
        do {
            guard let actionToReturn = try context.fetch(fetchRequest).first
            else {
                assertionFailure("Could not find action with id \(id)")
                throw DataManagerError.fetchError(entityName: "\(type(of: ExerciseActionEntity.self))", payload: .init(context: context))
            }
            
            return .success(actionToReturn)
        } catch {
            assertionFailure("Failed to fetch action: \(error)")
            return
                .failure(
                    .fetchError(
                        entityName: "\(type(of: ExerciseActionEntity.self))",
                        payload: .init(context: context, error: error)
                    )
                )
        }
    }

    func fetchExercise(exercise: ExerciseEntity, in context: NSManagedObjectContext) -> ExerciseEntity? {
        let fetchRequest: NSFetchRequest<ExerciseEntity> = ExerciseEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "SELF == %@", exercise.objectID)
        do {
            let exerciseToReturn = try context.fetch(fetchRequest).first
            return exerciseToReturn
        } catch {
            print("Error fetching exercise for temporary context: \(error)")
            return nil
        }
    }
    
    func fetchExercise(by uuid: UUID, in context: NSManagedObjectContext) -> ExerciseEntity? {
        let fetchRequest: NSFetchRequest<ExerciseEntity> = ExerciseEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uuid = %@", uuid as CVarArg)
        fetchRequest.fetchLimit = 1
        
        do {
            let exerciseToReturn = try context.fetch(fetchRequest).first
            return exerciseToReturn
        } catch {
           print("Error fetching exercise by UUID: \(error)")
           return nil
        }
    }
    
    func calculateNewActionPosition(for exercise: ExerciseEntity, in context: NSManagedObjectContext) -> Int16 {
        let actionCount = (fetchActions(for: exercise, in: context).last?.position ?? -1) + 1
        return Int16(actionCount)
    }
    
    func reindexExercises(for exercise: ExerciseEntity, in context: NSManagedObjectContext) {
        let fetchedActions = fetchActions(for: exercise, in: context)
        for (idx, action) in fetchedActions.enumerated() {
            action.position = idx.int16
        }
    }
    
    func updateActionPositions(
        _ positions: [UUID: Int],
        for exercise: ExerciseEntity,
        in context: NSManagedObjectContext
    ) {
        let fetchedActions = fetchActions(for: exercise, in: context)
        
        fetchedActions.forEach { action in
            if let uuid = action.uuid,
                let newPos = positions[uuid] {
                action.position = newPos.int16
            }
        }
    }
}
