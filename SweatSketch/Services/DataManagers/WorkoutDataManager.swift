//
//  WorkoutDataManager.swift
//  SweatSketch
//
//  Created by aibaranchikov on 08.04.2024.
//

import CoreData

class WorkoutDataManager {
    func createDefaultRestTime(
        for workout: WorkoutEntity,
        with duration: Int,
        in context: NSManagedObjectContext
    ) -> Result<RestTimeEntity, DataManagerError> {
        guard let workoutToUpdate = prepareWorkoutInContext(workout, in: context) else {
            return .failure(.fetchError(entityName: "Workout", payload: .init(context: context)))
        }
        
        let newDefaultRestTime = RestTimeEntity(context: context)
        newDefaultRestTime.uuid = UUID()
        newDefaultRestTime.isDefault = true
        newDefaultRestTime.duration = duration.int32
        newDefaultRestTime.workout = workoutToUpdate
        
        return .success(newDefaultRestTime)
    }
    
    func createExercise(
        for workout: WorkoutEntity,
        in context: NSManagedObjectContext
    ) -> Result<ExerciseEntity, DataManagerError> {
        guard let workoutToUpdate = prepareWorkoutInContext(workout, in: context) else {
            return .failure(.fetchError(entityName: "Workout", payload: .init(context: context)))
        }
        
        let newExercise = ExerciseEntity(context: context)
        newExercise.uuid = UUID()
        newExercise.position = calculateNewExercisePosition(for: workout, in: context)
        newExercise.workout = fetchWorkout(workout: workout, in: context)
        
        return .success(newExercise)
    }
    
    func createRestTime(
        workout: WorkoutEntity,
        for followingExercise: ExerciseEntity,
        with duration: Int,
        in context: NSManagedObjectContext
    ) -> Result<RestTimeEntity, DataManagerError> {
        guard let workoutToUpdate = prepareWorkoutInContext(workout, in: context) else {
            return .failure(.fetchError(entityName: "Workout", payload: .init(context: context)))
        }
        guard let exerciseToUpdate = prepareExerciseInContext(followingExercise, in: context) else {
            return .failure(.fetchError(entityName: "Exercise", payload: .init(context: context)))
        }
        
        let restTimeEntity = RestTimeEntity(context: context)
        restTimeEntity.uuid = UUID()
        restTimeEntity.isDefault = false
        restTimeEntity.duration = duration.int32
        restTimeEntity.workout = workoutToUpdate
        restTimeEntity.followingExercise = exerciseToUpdate
        
        return .success(restTimeEntity)
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
    
    func fetchExercises(for workout: WorkoutEntity, in context: NSManagedObjectContext) -> Result<[ExerciseEntity], DataManagerError> {
        let fetchRequest: NSFetchRequest<ExerciseEntity> = ExerciseEntity.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "position", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchRequest.predicate = NSPredicate(format: "workout == %@", workout)

        do {
            let exercisesToReturn = try context.fetch(fetchRequest)
            return .success(exercisesToReturn)
        } catch {
            print("Error fetching exercises for workout \(String(describing: workout.uuid)): \(error)")
            return
                .failure(
                    .fetchError(
                        entityName: "ExerciseEntity-multiple",
                        payload: .init(context: context, error: error)
                    )
                )
        }
    }
    
    func fetchExercise(exercise: ExerciseEntity, in context: NSManagedObjectContext) -> ExerciseEntity? {
        let exerciseFetchRequest: NSFetchRequest<ExerciseEntity> = ExerciseEntity.fetchRequest()
        exerciseFetchRequest.predicate = NSPredicate(format: "SELF == %@", exercise.objectID)
        exerciseFetchRequest.fetchLimit = 1
        
        do {
            return try context.fetch(exerciseFetchRequest).first
        } catch {
            print("\(type(of: self)): Error fetching exercise: \(error)")
            return nil
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
        guard case .success(let exercises) = fetchExercises(for: workout, in: context),
                let positionOfLastExercise = exercises.last?.position
        else { return 0 }
        
        return positionOfLastExercise + 1
    }
    
    func setupExercisePositions(for workout: WorkoutEntity, in context: NSManagedObjectContext) {
        guard case .success(let exercises) = fetchExercises(for: workout, in: context),
                !exercises.isEmpty
        else { return }
        
        for (index, exercise) in exercises.enumerated() {
            exercise.position = index.int16
        }
    }
}

extension WorkoutDataManager {
    private func prepareWorkoutInContext(_ workout: WorkoutEntity, in context: NSManagedObjectContext) -> WorkoutEntity? {
        if workout.managedObjectContext == context {
            return workout
        } else {
            return fetchWorkout(workout: workout, in: context)
        }
    }
    
    private func prepareExerciseInContext(_ exercise: ExerciseEntity, in context: NSManagedObjectContext) -> ExerciseEntity? {
        if exercise.managedObjectContext == context {
            return exercise
        } else {
            return fetchExercise(exercise: exercise, in: context)
        }
    }
}
