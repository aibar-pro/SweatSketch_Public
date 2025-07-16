//
//  WorkoutDataManager.swift
//  SweatSketch
//
//  Created by aibaranchikov on 08.04.2024.
//

import CoreData

class WorkoutDataManager {
    func createExercise(
        for workout: WorkoutEntity,
        intraRest: Int? = nil,
        in context: NSManagedObjectContext
    ) -> Result<ExerciseEntity, DataManagerError> {

        let newExercise = ExerciseEntity(context: context)
        newExercise.uuid = UUID()
        newExercise.position = calculateNewExercisePosition(for: workout, in: context)
        newExercise.workout = fetchWorkout(workout: workout, in: context)
        newExercise.intraRest = intraRest?.nsNumber
        
        return .success(newExercise)
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
    
    func removeWorkout(with id: UUID, in context: NSManagedObjectContext) {
        guard let workoutToDelete = fetchWorkout(by: id, in: context)
        else {
            assertionFailure("Could not find exercise with id \(id) to delete")
            return
        }
        context.delete(workoutToDelete)
    }
    
    func calculateNewExercisePosition(for workout: WorkoutEntity, in context: NSManagedObjectContext) -> Int16 {
        guard case .success(let exercises) = fetchExercises(for: workout, in: context),
                let positionOfLastExercise = exercises.last?.position
        else { return 0 }
        
        return positionOfLastExercise + 1
    }
    
    func reindexExercises(for workout: WorkoutEntity, in context: NSManagedObjectContext) {
        guard case .success(let exercises) = fetchExercises(for: workout, in: context),
                !exercises.isEmpty
        else { return }
        
        for (index, exercise) in exercises.enumerated() {
            exercise.position = index.int16
        }
    }
    
    func updateExercisePositions(
        _ positions: [UUID: Int],
        for workout: WorkoutEntity,
        in context: NSManagedObjectContext
    ) {
        guard let fetchedExercises = try? fetchExercises(for: workout, in: context).get()
        else { return }
        
        fetchedExercises.forEach { exercise in
            if let uuid = exercise.uuid,
                let newPos = positions[uuid] {
                exercise.position = newPos.int16
            }
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
