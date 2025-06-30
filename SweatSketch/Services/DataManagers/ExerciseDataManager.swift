//
//  ExerciseDataManager.swift
//  SweatSketch
//
//  Created by aibaranchikov on 08.04.2024.
//

import CoreData

final class ExerciseDataManager {
    func createRestBetweenActions(
        for exercise: ExerciseEntity,
        with duration: Int,
        in context: NSManagedObjectContext
    ) -> RestActionEntity {
        let newRestTime = RestActionEntity(context: context)
        
        newRestTime.uuid = UUID()
        newRestTime.duration = duration.int32
        
        newRestTime.exercise = fetchExercise(exercise: exercise, in: context)
        
        return newRestTime
    }

    func createRepsAction(for exercise: ExerciseEntity, from draft: ActionDraftModel, in context: NSManagedObjectContext) -> Result<UUID, DataManagerError> {
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
    
    func removeAction(with id: UUID, from exercise: ExerciseEntity, in context: NSManagedObjectContext) {
        guard let actionToDelete = try? fetchAction(with: id, in: context).get()
        else {
            assertionFailure("Could not find action with id \(id) to delete")
            return
        }
        context.delete(actionToDelete)
    }
    
    func fetchActions(for exercise: ExerciseEntity, in context: NSManagedObjectContext) -> [ExerciseActionEntity] {
        let fetchRequest: NSFetchRequest<ExerciseActionEntity> = ExerciseActionEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "exercise == %@", exercise)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "position", ascending: true)]
        
        do {
            let all = try context.fetch(fetchRequest)
            return all.filter { !($0 is RestActionEntity) }
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
    
    func fetchRestTimeBetweenActions(for exercise: ExerciseEntity, in context: NSManagedObjectContext) -> RestActionEntity? {
        let fetchRequest: NSFetchRequest<RestActionEntity> = RestActionEntity.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "exercise == %@", exercise)
        
        do {
            return try context.fetch(fetchRequest).first
        } catch {
            print("Error fetching actions: \(error)")
            return nil
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
    
    func setupActionPositions(for exercise: ExerciseEntity, in context: NSManagedObjectContext) {
        let actions = fetchActions(for: exercise, in: context)
        for (index, action) in actions.enumerated() {
            action.position = index.int16
        }
    }
}
