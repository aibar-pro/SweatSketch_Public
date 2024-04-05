//
//  WorkoutDataManager.swift
//  SweatSketch
//
//  Created by aibaranchikov on 08.04.2024.
//

import CoreData

class WorkoutDataManager: WorkoutDataManagerProtocol {
    func createDefaultWorkout(position: Int16, in context: NSManagedObjectContext) -> WorkoutEntity {
        let newWorkout = WorkoutEntity(context: context)
        newWorkout.uuid = UUID()
        newWorkout.name = Constants.Design.Placeholders.noWorkoutName
        newWorkout.position = position
        
        return newWorkout
    }
    
    func fetchDefaultRestTime(for workout: WorkoutEntity, in context: NSManagedObjectContext) -> RestTimeEntity? {
        let fetchRequest: NSFetchRequest<RestTimeEntity> = RestTimeEntity.fetchRequest()
        fetchRequest.fetchLimit = 1
        
        let isDefaultPredicate = NSPredicate(format: "isDefault == %@", NSNumber(value: true))
        let workoutPredicate = NSPredicate(format: "workout == %@", workout)

        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [isDefaultPredicate, workoutPredicate])
        
        do {
            let restTimeToReturn = try context.fetch(fetchRequest).first
            return restTimeToReturn
        } catch {
            print("Error fetching workout: \(error)")
            return nil
        }
    }
    
    func fetchExercises(for workout: WorkoutEntity, in context: NSManagedObjectContext) -> [ExerciseEntity] {
        let fetchRequest: NSFetchRequest<ExerciseEntity> = ExerciseEntity.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "order", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchRequest.predicate = NSPredicate(format: "workout == %@", workout)

        do {
            let exercisesToReturn = try context.fetch(fetchRequest)
            return exercisesToReturn
        } catch {
            print("Error fetching exercises for workout \(String(describing: workout.uuid)): \(error)")
            return []
        }
    }
    
    func fetchWorkout(workout: WorkoutEntity, in context: NSManagedObjectContext) -> WorkoutEntity? {
        let workoutFetchRequest: NSFetchRequest<WorkoutEntity> = WorkoutEntity.fetchRequest()
        workoutFetchRequest.predicate = NSPredicate(format: "SELF == %@", workout.objectID)
        do {
            let workoutToReturn = try context.fetch(workoutFetchRequest).first
            return workoutToReturn
        } catch {
            print("Error fetching workout: \(error)")
            return nil
        }
    }
    
    func fetchWorkout(by uuid: UUID, in context: NSManagedObjectContext) -> WorkoutEntity? {
        let fetchRequest: NSFetchRequest<WorkoutEntity> = WorkoutEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uuid = %@", uuid as CVarArg)
        fetchRequest.fetchLimit = 1
        
        do {
            let workoutToReturn = try context.fetch(fetchRequest).first
            return workoutToReturn
        } catch {
           print("Error fetching workout by UUID: \(error)")
           return nil
        }
    }
}
