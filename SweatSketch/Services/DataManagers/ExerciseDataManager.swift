//
//  ExerciseDataManager.swift
//  SweatSketch
//
//  Created by aibaranchikov on 08.04.2024.
//

import CoreData

class ExerciseDataManager: ExerciseDataManagerProtocol {
    
    func createRestTimeBetweenActions(
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
    
    func createAction(for exercise: ExerciseEntity, in context: NSManagedObjectContext) -> ExerciseActionEntity {
        let newAction = ExerciseActionEntity(context: context)
//        
//        newAction.uuid = UUID()
//        newAction.isRestTime = false
//        newAction.position = calculateNewActionPosition(for: exercise, in: context)
//        
//        switch ExerciseType.from(rawValue: exercise.type) {
//        case .timed:
//            newAction.type = ExerciseActionType.timed.rawValue
//            newAction.duration = Int32(Constants.DefaultValues.actionDuration)
//        case .mixed:
//            newAction.name = Constants.Placeholders.noActionName
//            fallthrough
//        default:
//            newAction.type = ExerciseActionType.setsNreps.rawValue
//            newAction.sets = Int16(Constants.DefaultValues.setsCount)
//            newAction.reps = Int16(Constants.DefaultValues.repsCount)
//        }
//        
//        newAction.exercise = fetchExercise(exercise: exercise, in: context)
//        
        return newAction
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
