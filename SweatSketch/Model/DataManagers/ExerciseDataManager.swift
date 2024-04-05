//
//  ExerciseDataManager.swift
//  SweatSketch
//
//  Created by aibaranchikov on 08.04.2024.
//

import CoreData

class ExerciseDataManager: ExerciseDataManagerProtocol {
    func createDefaultExercise(position: Int16, in context: NSManagedObjectContext) -> ExerciseEntity {
        let newExercise = ExerciseEntity(context: context)
        newExercise.uuid = UUID()
        newExercise.name = Constants.Design.Placeholders.noExerciseName
        newExercise.order = position
        newExercise.type = ExerciseType.setsNreps.rawValue
        
        return newExercise
    }
    
    func createDefaultRestTimeBetweenActions(for duration: Int?, in context: NSManagedObjectContext) -> ExerciseActionEntity {
        let newRestTime = ExerciseActionEntity(context: context)
        newRestTime.uuid = UUID()
        newRestTime.isRestTime = true
        newRestTime.duration = Int32(duration ?? Constants.DefaultValues.restTimeDuration)
        
        return newRestTime
    }
    
    func fetchActions(for exercise: ExerciseEntity, in context: NSManagedObjectContext) -> [ExerciseActionEntity] {
        let fetchRequest: NSFetchRequest<ExerciseActionEntity> = ExerciseActionEntity.fetchRequest()
        fetchRequest.fetchLimit = 1
        
        let isRestTimePredicate = NSPredicate(format: "isRestTime == %@", NSNumber(value: false))
        let exercisePredicate = NSPredicate(format: "exercise == %@", exercise)

        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [isRestTimePredicate, exercisePredicate])
        
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
}
