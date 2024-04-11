//
//  WorkoutDataManager.swift
//  SweatSketch
//
//  Created by aibaranchikov on 08.04.2024.
//

import CoreData

class WorkoutDataManager: WorkoutDataManagerProtocol {
    func createDefaultRestTime(for workout: WorkoutEntity, in context: NSManagedObjectContext) -> RestTimeEntity {
        let newDefaultRestTime = RestTimeEntity(context: context)
        newDefaultRestTime.uuid = UUID()
        newDefaultRestTime.isDefault = true
        newDefaultRestTime.duration = Int32(Constants.DefaultValues.restTimeDuration)
        newDefaultRestTime.workout = fetchWorkout(workout: workout, in: context)
        
        return newDefaultRestTime
    }
    
    func createExercise(for workout: WorkoutEntity, in context: NSManagedObjectContext) -> ExerciseEntity {
        let newExercise = ExerciseEntity(context: context)
        newExercise.uuid = UUID()
        newExercise.name = Constants.Placeholders.noExerciseName
        newExercise.position = calculateNewExercisePosition(for: workout, in: context)
        newExercise.type = ExerciseType.setsNreps.rawValue
        //Undo-redo for workout edit is not working correctly
//        newExercise.workout = fetchWorkout(workout: workout, in: context)
        
        return newExercise
    }
    
    func createRestTime(for followingExercise: ExerciseEntity, with duration: Int, in context: NSManagedObjectContext) -> RestTimeEntity? {
        guard let workout = followingExercise.workout else { return nil }
        
        let newDefaultRestTime = RestTimeEntity(context: context)
        newDefaultRestTime.uuid = UUID()
        newDefaultRestTime.isDefault = false
        newDefaultRestTime.duration = Int32(duration)
        
        newDefaultRestTime.workout = fetchWorkout(workout: workout, in: context)
        let exerciseDataManager = ExerciseDataManager()
        newDefaultRestTime.followingExercise = exerciseDataManager.fetchExercise(exercise: followingExercise, in: context)
        
        return newDefaultRestTime
    }
    
    func fetchRestTime(for followingExercise: ExerciseEntity, in context: NSManagedObjectContext) -> RestTimeEntity? {
        let fetchRequest: NSFetchRequest<RestTimeEntity> = RestTimeEntity.fetchRequest()
        fetchRequest.fetchLimit = 1

        fetchRequest.predicate = NSPredicate(format: "followingExercise == %@", followingExercise)
        
        do {
            let restTimeToReturn = try context.fetch(fetchRequest).first
            return restTimeToReturn
        } catch {
            print("Error fetching rest time: \(error)")
            return nil
        }
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
            print("Error fetching default rest time: \(error)")
            return nil
        }
    }
    
    func fetchExercises(for workout: WorkoutEntity, in context: NSManagedObjectContext) -> [ExerciseEntity] {
        let fetchRequest: NSFetchRequest<ExerciseEntity> = ExerciseEntity.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "position", ascending: true)
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
    
    func calculateNewExercisePosition(for workout: WorkoutEntity, in context: NSManagedObjectContext) -> Int16 {
        let newExercisePosition = (fetchExercises(for: workout, in: context).last?.position ?? -1) + 1
        return Int16(newExercisePosition)
    }
    
    func setupExercisePositions(for workout: WorkoutEntity, in context: NSManagedObjectContext) {
        let exercises = fetchExercises(for: workout, in: context)
        for (index, exercise) in exercises.enumerated() {
            exercise.position = Int16(index)
        }
    }
}
