//
//  ExerciseDataManager.swift
//  SweatSketch
//
//  Created by aibaranchikov on 08.04.2024.
//

import CoreData

class ExerciseDataManager: ExerciseDataManagerProtocol {
    
    func createRestTimeBetweenActions(for exercise: ExerciseEntity, with duration: Int, in context: NSManagedObjectContext) -> ExerciseActionEntity {
        let newRestTime = ExerciseActionEntity(context: context)
        
        newRestTime.uuid = UUID()
        newRestTime.isRestTime = true
        newRestTime.position = 0
        newRestTime.duration = Int32(duration)
        
        newRestTime.exercise = fetchExercise(exercise: exercise, in: context)
        
        return newRestTime
    }
    
    func createAction(for exercise: ExerciseEntity, in context: NSManagedObjectContext) -> ExerciseActionEntity {
        let newAction = ExerciseActionEntity(context: context)
        
        newAction.uuid = UUID()
        newAction.name = Constants.Placeholders.noActionName
        newAction.isRestTime = false
        newAction.position = calculateNewActionPosition(for: exercise, in: context)
        
        switch ExerciseType.from(rawValue: exercise.type) {
        case .timed:
            newAction.type = ExerciseActionType.timed.rawValue
            newAction.duration = Int32(Constants.DefaultValues.actionDuration)
        default:
            newAction.type = ExerciseActionType.setsNreps.rawValue
            newAction.sets = Int16(Constants.DefaultValues.setsCount)
            newAction.reps = Int16(Constants.DefaultValues.repsCount)
        }
        
        newAction.exercise = fetchExercise(exercise: exercise, in: context)
        
        return newAction
    }
    
    func fetchActions(for exercise: ExerciseEntity, in context: NSManagedObjectContext) -> [ExerciseActionEntity] {
        let fetchRequest: NSFetchRequest<ExerciseActionEntity> = ExerciseActionEntity.fetchRequest()
        
        let isRestTimeFalsePredicate = NSPredicate(format: "isRestTime == %@", NSNumber(value: false))
        let isRestTimeNilPredicate = NSPredicate(format: "isRestTime == nil")
        
        let isRestTimePredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [isRestTimeNilPredicate, isRestTimeFalsePredicate])
        
        let exercisePredicate = NSPredicate(format: "exercise == %@", exercise)

        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [isRestTimePredicate, exercisePredicate])
        
        let sortDescriptor = NSSortDescriptor(key: "position", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let actionsToReturn = try context.fetch(fetchRequest)
            return actionsToReturn
        } catch {
            print("Error fetching actions: \(error)")
            return []
        }
    }
    
    func fetchRestTimeBetweenActions(for exercise: ExerciseEntity, in context: NSManagedObjectContext) -> ExerciseActionEntity? {
        let fetchRequest: NSFetchRequest<ExerciseActionEntity> = ExerciseActionEntity.fetchRequest()
        fetchRequest.fetchLimit = 1
        
        let isRestTimePredicate = NSPredicate(format: "isRestTime == %@", NSNumber(value: true))
        let exercisePredicate = NSPredicate(format: "exercise == %@", exercise)

        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [isRestTimePredicate, exercisePredicate])
        
        do {
            let restTimeToReturn = try context.fetch(fetchRequest).first
            return restTimeToReturn
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
    
    func calculateNewActionPosition(for exercise: ExerciseEntity, in context: NSManagedObjectContext) -> Int16 {
        let actionCount = (fetchActions(for: exercise, in: context).last?.position ?? -1) + 1
        return Int16(actionCount)
    }
    
    func setupActionPositions(for exercise: ExerciseEntity, in context: NSManagedObjectContext) {
        let actions = fetchActions(for: exercise, in: context)
        for (index, action) in actions.enumerated() {
            action.position = Int16(index)
        }
    }
}
