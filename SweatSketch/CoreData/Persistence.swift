//
//  Persistence.swift
//  MyWorkoutPlanner
//
//  Created by aibaranchikov on 7/5/21.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let maxWorkoutCount = 10
        let maxExerciseCount = 15
        let maxActionCount = 10
        
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        let root = createCollection(in: viewContext, name: "Root Workout Collection", position: 0)
        let parent = createCollection(in: viewContext, name: "Collection with sub", position: 1)
        let sub1 = createCollection(in: viewContext, name: "Sub collection 1", position: 0, parent: parent)
        let sub2 = createCollection(in: viewContext, name: "Sub collection 2 Sub collection 2 Sub collection 2 Sub collection 2 Sub collection 2", position: 1, parent: parent)
        
        let defaultCollection = createDefaultCollection(in: viewContext)
        
        let planCount = Int.random(in: 1...maxWorkoutCount)
        for idx in 1...planCount {
            let c = [root, parent, sub1, sub2, defaultCollection].randomElement() ?? nil
            
            let w = createWorkout(
                in: viewContext,
                name: "Test Workout Auto \(idx)",
                position: Int16(idx),
                collection: c
            )
            _ = createDefaultRestTime(
                in: viewContext,
                duration: Int32.random(in: 60...180),
                workout: w
            )
            
            print("MOCK: Created workout \(w)")
            let exerciseCount = Int.random(in: 0...maxExerciseCount)
            for eIdx in 0..<exerciseCount {
                let exType = Int.random(in: 0...2)
                switch exType {
                case 0:
                    _ = createTimedExercise(
                        in: viewContext,
                        workout: w,
                        position: Int16(eIdx + 1),
                        maxActionCount: maxActionCount
                    )
                case 1:
                    _ = createDistanceExercise(
                        in: viewContext,
                        workout: w,
                        position: Int16(eIdx + 1),
                        maxActionCount: maxActionCount
                    )
                case 2:
                    _ = createMixedExercise(
                        in: viewContext,
                        workout: w,
                        position: Int16(eIdx + 1),
                        maxActionCount: maxActionCount
                    )
                default:
                    _ = createRepsExercise(
                        in: viewContext,
                        workout: w,
                        position: Int16(eIdx + 1),
                        maxActionCount: maxActionCount
                    )
                }
            }
            if Bool.random(),
                let ex = w.exercises?.array.randomElement() as? ExerciseEntity {
                _ = createRestTime(
                    in: viewContext,
                    duration: Int32.random(in: 60...180),
                    followingExercise: ex,
                    workout: w
                )
            }
        }

//        printPreviewSummary(in: viewContext)
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "SweatSketchData")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}

extension PersistenceController {
    private static func createDefaultCollection(
        in context: NSManagedObjectContext
    ) -> WorkoutCollectionEntity {
        let col = WorkoutCollectionEntity(context: context)
        col.uuid = UUID()
        col.type = WorkoutCollectionType.defaultCollection.rawValue
        return col
    }
    
    private static func createCollection(
        in context: NSManagedObjectContext,
        name: String,
        position: Int16,
        parent: WorkoutCollectionEntity? = nil
    ) -> WorkoutCollectionEntity {
        let col = WorkoutCollectionEntity(context: context)
        col.uuid = UUID()
        col.name = name
        col.type = WorkoutCollectionType.user.rawValue
        col.position = position
        col.parentCollection = parent
        return col
    }
    
    private static func createWorkout(
        in context: NSManagedObjectContext,
        name: String?,
        position: Int16,
        collection: WorkoutCollectionEntity? = nil
    ) -> WorkoutEntity {
        let workout = WorkoutEntity(context: context)
        workout.uuid = UUID()
        workout.name = name ?? ""
        workout.position = position
        if let collection {
            workout.collection = collection
        }
        return workout
    }
    
    private static func createDefaultRestTime(
        in context: NSManagedObjectContext,
        duration: Int32,
        workout: WorkoutEntity
    ) -> RestTimeEntity {
        let restTime = RestTimeEntity(context: context)
        restTime.uuid = UUID()
        restTime.isDefault = true
        restTime.duration = duration
        workout.addToRestTimes(restTime)
        return restTime
    }
    
    private static func createRestTime(
        in context: NSManagedObjectContext,
        duration: Int32,
        followingExercise: ExerciseEntity,
        workout: WorkoutEntity
    ) -> RestTimeEntity {
        let restTime = RestTimeEntity(context: context)
        restTime.uuid = UUID()
        restTime.followingExercise = followingExercise
        restTime.duration = duration
        workout.addToRestTimes(restTime)
        return restTime
    }
    
    private static func createExercise(
        in context: NSManagedObjectContext,
        name: String,
        position: Int16
    ) -> ExerciseEntity {
        let exercise = ExerciseEntity(context: context)
        exercise.uuid = UUID()
        exercise.name = name
        exercise.position = position
        exercise.superSets = Int16.random(in: 1...11)
        return exercise
    }

    private static func createTimedAction(
        in context: NSManagedObjectContext,
        exercise: ExerciseEntity,
        position: Int16
    ) {
        let action = TimedActionEntity(context: context)
        action.uuid = UUID()
        action.position = position
        action.sets = Int16.random(in: 1...5)
        action.secondsMin = Int32.random(in: 30...120)
        if Bool.random() {
            action.secondsMax = NSNumber(value: Int.random(in: 150...5000))
        }
        action.isMax = Bool.random()
        exercise.addToExerciseActions(action)
    }

    private static func createRepsAction(
        in context: NSManagedObjectContext,
        exercise: ExerciseEntity,
        position: Int16
    ) {
        let action = RepsActionEntity(context: context)
        action.uuid = UUID()
        action.position = position
        action.sets = Int16.random(in: 1...5)
        action.repsMin = Int16.random(in: 6...12)
        if Bool.random() {
            action.repsMax = NSNumber(value: Int.random(in: 13...24))
        }
        action.isMax = Bool.random()
        exercise.addToExerciseActions(action)
    }

    private static func createDistanceAction(
        in context: NSManagedObjectContext,
        exercise: ExerciseEntity,
        position: Int16,
    ) {
        let action = DistanceActionEntity(context: context)
        action.uuid = UUID()
        action.position = position
        action.sets = Int16.random(in: 1...5)
        action.distanceMin = Double.random(in: 1...2500)
        if Bool.random() {
            action.distanceMax = NSNumber(value: Double.random(in: 2501...10000))
        }
        action.unit = "test"
        action.isMax = Bool.random()
        exercise.addToExerciseActions(action)
    }
    
    private static func createRestAction(
        in context: NSManagedObjectContext,
        exercise: ExerciseEntity,
        duration: Int
    ) {
        let action = RestActionEntity(context: context)
        action.uuid = UUID()
        action.duration = duration.int32
        exercise.addToExerciseActions(action)
    }
    
    private static func createRepsExercise(
        in context: NSManagedObjectContext,
        workout: WorkoutEntity,
        position: Int16,
        maxActionCount: Int
    ) -> ExerciseEntity {
        let ex = createExercise(in: context, name: "Reps \(position)", position: position)
        let aCount = Int.random(in: 1...maxActionCount)
        for idx in 1...aCount {
            createRepsAction(
                in: context,
                exercise: ex,
                position: Int16(idx)
            )
        }
        if Bool.random() {
            createRestAction(in: context, exercise: ex, duration: Int.random(in: 5...100))
        }
        workout.addToExercises(ex)
        return ex
    }
    
    private static func createDistanceExercise(
        in context: NSManagedObjectContext,
        workout: WorkoutEntity,
        position: Int16,
        maxActionCount: Int
    ) -> ExerciseEntity {
        let ex = createExercise(in: context, name: "Distance \(position)", position: position)
        let aCount = Int.random(in: 1...maxActionCount)
        for idx in 1...aCount {
            createDistanceAction(
                in: context,
                exercise: ex,
                position: Int16(idx)
            )
        }
        if Bool.random() {
            createRestAction(in: context, exercise: ex, duration: Int.random(in: 5...100))
        }
        workout.addToExercises(ex)
        return ex
    }
    
    private static func createTimedExercise(
        in context: NSManagedObjectContext,
        workout: WorkoutEntity,
        position: Int16,
        maxActionCount: Int
    ) -> ExerciseEntity {
        let ex = createExercise(in: context, name: "Timed \(position)", position: position)
        let aCount = Int.random(in: 1...maxActionCount)
        for idx in 1...aCount {
            createTimedAction(
                in: context,
                exercise: ex,
                position: Int16(idx)
            )
        }
        if Bool.random() {
            createRestAction(in: context, exercise: ex, duration: Int.random(in: 5...100))
        }
        workout.addToExercises(ex)
        return ex
    }
    
    private static func createMixedExercise(
        in context: NSManagedObjectContext,
        workout: WorkoutEntity,
        position: Int16,
        maxActionCount: Int
    ) -> ExerciseEntity {
        let ex = createExercise(in: context, name: "Mixed \(position)", position: position)
        let aCount = Int.random(in: 1...maxActionCount)
        for idx in 1...aCount {
            let actionType = Int.random(in: 1...3)
            switch actionType {
            case 1:
                createTimedAction(
                    in: context,
                    exercise: ex,
                    position: Int16(idx)
                )
            case 2:
                createDistanceAction(
                    in: context,
                    exercise: ex,
                    position: Int16(idx)
                )
            default:
                createRepsAction(
                    in: context,
                    exercise: ex,
                    position: Int16(idx)
                )
            }
        }
        if Bool.random() {
            createRestAction(in: context, exercise: ex, duration: Int.random(in: 5...100))
        }
        workout.addToExercises(ex)
        return ex
    }
}
