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
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        let collection = WorkoutCollectionEntity(context: viewContext)
        collection.uuid = UUID()
        collection.name = "Test Workout Collection"
        collection.type = WorkoutCollectionType.user.rawValue
        collection.position = Int16(0)
        
        let collectionWithSub = WorkoutCollectionEntity(context: viewContext)
        collectionWithSub.uuid = UUID()
        collectionWithSub.name = "Collection with sub"
        collectionWithSub.position = Int16(1)
        
        let subCollection = WorkoutCollectionEntity(context: viewContext)
        subCollection.uuid = UUID()
        subCollection.name = "Sub collection"
        subCollection.position = Int16(0)
        subCollection.parentCollection = collectionWithSub
        
        let subCollection2 = WorkoutCollectionEntity(context: viewContext)
        subCollection2.uuid = UUID()
        subCollection2.name = "Sub collection 2"
        subCollection2.position = Int16(1)
        subCollection2.parentCollection = collectionWithSub
        
        let planCount = Int.random(in: 1...3)
        
        let workout = WorkoutEntity(context: viewContext)
        workout.uuid = UUID()
        workout.name = "Test Workout Auto \(0) Test Workout Auto Test Workout Auto"
        workout.position = Int16(0)
        workout.collection = subCollection
        let defaultRestTime = RestTimeEntity(context: viewContext)
        defaultRestTime.uuid = UUID()
        defaultRestTime.isDefault = true
        defaultRestTime.duration = 180
        defaultRestTime.workout = workout
        
        let workout2 = WorkoutEntity(context: viewContext)
        workout2.uuid = UUID()
        workout2.name = "Test Workout Auto \(1) Test Workout Auto Test Workout Auto"
        workout2.position = Int16(1)
        workout2.collection = subCollection
        
        let newTimedExercise = ExerciseEntity(context: viewContext)
        newTimedExercise.uuid = UUID()
        newTimedExercise.name = String("Test Timed Exercise")
        newTimedExercise.position = Int16(0)
        newTimedExercise.type = ExerciseType.timed.rawValue
        let newExerciseTimedAction = ExerciseActionEntity(context: viewContext)
        newExerciseTimedAction.uuid = UUID()
        newExerciseTimedAction.position = Int16(1)
        newExerciseTimedAction.duration = Int32.random(in: 600...10000)
        newExerciseTimedAction.type = ExerciseActionType.timed.rawValue
        newTimedExercise.addToExerciseActions(newExerciseTimedAction)
        let newExerciseTimedAction1 = ExerciseActionEntity(context: viewContext)
        newExerciseTimedAction1.uuid = UUID()
        newExerciseTimedAction1.position = Int16(2)
        newExerciseTimedAction1.duration = Int32.random(in: 50000...100000)
        newExerciseTimedAction1.type = ExerciseActionType.timed.rawValue
        newTimedExercise.addToExerciseActions(newExerciseTimedAction1)
        workout.addToExercises(newTimedExercise)
        
        let newSNRExercise = ExerciseEntity(context: viewContext)
        newSNRExercise.uuid = UUID()
        newSNRExercise.name = String("Test Sets-n-Reps Exercise")
        newSNRExercise.position = Int16(1)
        newSNRExercise.type = ExerciseType.setsNreps.rawValue
        let newExerciseSNRAction = ExerciseActionEntity(context: viewContext)
        newExerciseSNRAction.uuid = UUID()
        newExerciseSNRAction.position = Int16(1)
        newExerciseSNRAction.type = ExerciseActionType.setsNreps.rawValue
        newExerciseSNRAction.sets = Int16(3)
        newExerciseSNRAction.reps = Int16(12)
        let newExerciseSNRMAXAction = ExerciseActionEntity(context: viewContext)
        newExerciseSNRMAXAction.uuid = UUID()
        newExerciseSNRMAXAction.position = Int16(2)
        newExerciseSNRMAXAction.type = ExerciseActionType.setsNreps.rawValue
        newExerciseSNRMAXAction.sets = Int16(5)
        newExerciseSNRMAXAction.repsMax = true
        newSNRExercise.addToExerciseActions(newExerciseSNRAction)
        newSNRExercise.addToExerciseActions(newExerciseSNRMAXAction)
        workout.addToExercises(newSNRExercise)
        
        let newSupersetExercise = ExerciseEntity(context: viewContext)
        newSupersetExercise.uuid = UUID()
        newSupersetExercise.name = String("Test Superset Exercise")
        newSupersetExercise.position = Int16(4)
        newSupersetExercise.superSets = Int16(3)
        newSupersetExercise.type = ExerciseType.mixed.rawValue
        let newExerciseAction1 = ExerciseActionEntity(context: viewContext)
        newExerciseAction1.uuid = UUID()
        newExerciseAction1.name = "Treadmill run"
        newExerciseAction1.duration = Int32(180)
        newExerciseAction1.position = Int16(0)
        newExerciseAction1.type = ExerciseActionType.timed.rawValue
        newSupersetExercise.addToExerciseActions(newExerciseAction1)
        let newExerciseAction2 = ExerciseActionEntity(context: viewContext)
        newExerciseAction2.uuid = UUID()
        newExerciseAction2.name = "Deadlift"
        newExerciseAction2.reps = Int16(12)
        newExerciseAction2.sets = Int16(1)
        newExerciseAction2.position = Int16(1)
        newExerciseAction2.type = ExerciseActionType.setsNreps.rawValue
        newExerciseAction2.weightType = WeightType.barbell.rawValue
        newSupersetExercise.addToExerciseActions(newExerciseAction2)
        let newExerciseAction3 = ExerciseActionEntity(context: viewContext)
        newExerciseAction3.uuid = UUID()
        newExerciseAction3.name = "Lat Pulldowns"
        newExerciseAction3.repsMax = true
        newExerciseAction3.sets = Int16(1)
        newExerciseAction3.position = Int16(2)
        newExerciseAction3.type = ExerciseActionType.setsNreps.rawValue
        newExerciseAction3.weightType = WeightType.machine.rawValue
        newSupersetExercise.addToExerciseActions(newExerciseAction3)
        let newExerciseAction4 = ExerciseActionEntity(context: viewContext)
        newExerciseAction4.uuid = UUID()
        newExerciseAction4.name = "Burpees"
        newExerciseAction4.reps = Int16(5)
        newExerciseAction4.sets = Int16(1)
        newExerciseAction4.position = Int16(3)
        newExerciseAction4.type = ExerciseActionType.setsNreps.rawValue
        newExerciseAction4.weightType = WeightType.body.rawValue
        newSupersetExercise.addToExerciseActions(newExerciseAction4)
        let newExerciseAction5 = ExerciseActionEntity(context: viewContext)
        newExerciseAction5.uuid = UUID()
        newExerciseAction5.position = Int16(4)
        newExerciseAction5.type = ExerciseActionType.timed.rawValue
        newSupersetExercise.addToExerciseActions(newExerciseAction5)
        workout.addToExercises(newSupersetExercise)
        
        for w in 1...planCount {
            let workout = WorkoutEntity(context: viewContext)
            workout.uuid = UUID()
            workout.name = "Test Workout Auto \(w) Test Workout Auto Test Workout Auto"
            workout.position = Int16(w)
            
            let exerciseCount = Int.random(in: 0...20)
            
            for e in 0...exerciseCount {
                let newExercise = ExerciseEntity(context: viewContext)
                newExercise.uuid = UUID()
                newExercise.position = Int16(e+3)
                newExercise.type = ExerciseType.setsNreps.rawValue
                
                let actionCount = Int.random(in: 0...5)
                
                for a in 0...actionCount {
                    let newExerciseAction = ExerciseActionEntity(context: viewContext)
                    newExerciseAction.uuid = UUID()
                    newExerciseAction.reps = Int16.random(in: 6...10)
                    newExerciseAction.sets = Int16.random(in: 1...4)
                    newExerciseAction.position = Int16(a)
                    newExerciseAction.type = ExerciseActionType.setsNreps.rawValue
                    newExercise.addToExerciseActions(newExerciseAction)
                }
                
                workout.addToExercises(newExercise)
            }
        }
        
        let untitledWorkout = WorkoutEntity(context: viewContext)
        untitledWorkout.uuid = UUID()
        untitledWorkout.position = Int16(planCount+1)

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
