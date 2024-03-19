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
        
//        var weightPlates : [WeightPlate] = []
//        var weightCount = 10
//        for i in 1...weightCount {
//            let newPlate = WeightPlate(context: viewContext)
//            newPlate.weight = Double(10 * i)
//            weightPlates.append(newPlate)
//        }
        
        let planCount = Int.random(in: 0...2)
        
        for w in 0...planCount {
            let workout = WorkoutEntity(context: viewContext)
            workout.uuid = UUID()
            workout.name = "Test Workout Auto \(w) Test Workout Auto Test Workout Auto"
            workout.position = Int16(w)
            
            let exerciseCount = Int.random(in: 0...20)
            
            for e in 0...exerciseCount {
                let newExercise = ExerciseEntity(context: viewContext)
                newExercise.uuid = UUID()
                newExercise.name = String("Test Exercise \(w)-\(e)")
                newExercise.order = Int16(e)
                newExercise.type = ExerciseType.setsNreps.rawValue
                
                let actionCount = Int.random(in: 0...5)
                
                for a in 0...actionCount {
                    let newExerciseAction = ExerciseActionEntity(context: viewContext)
                    newExerciseAction.uuid = UUID()
                    newExerciseAction.name = "Test Exercise \(w)-\(e)-\(a)"
                    newExerciseAction.reps = Int16.random(in: 6...10)
                    newExerciseAction.sets = Int16.random(in: 1...4)
                    newExerciseAction.order = Int16(a)
                    newExerciseAction.type = ExerciseActionType.setsNreps.rawValue
                    newExercise.addToExerciseActions(newExerciseAction)
                }
                
                workout.addToExercises(newExercise)
            }
            
            let newTimedExercise = ExerciseEntity(context: viewContext)
            newTimedExercise.uuid = UUID()
            newTimedExercise.name = String("Test Timed Exercise \(w)-\(exerciseCount+1)")
            newTimedExercise.order = Int16(exerciseCount+2)
            newTimedExercise.type = ExerciseType.timed.rawValue
            
            let newExerciseTimedAction = ExerciseActionEntity(context: viewContext)
            newExerciseTimedAction.uuid = UUID()
            newExerciseTimedAction.name = "Treadmill run"
            newExerciseTimedAction.duration = Int16.random(in: 600...10000)
            newExerciseTimedAction.order = Int16(1)
            newExerciseTimedAction.type = ExerciseActionType.timed.rawValue
            
            newTimedExercise.addToExerciseActions(newExerciseTimedAction)
            workout.addToExercises(newTimedExercise)
            
            let newSupersetExercise = ExerciseEntity(context: viewContext)
            newSupersetExercise.uuid = UUID()
            newSupersetExercise.name = String("Test Superset Exercise \(w)-\(exerciseCount+2)")
            newSupersetExercise.order = Int16(exerciseCount+2)
            newSupersetExercise.superSets = Int16(3)
            newSupersetExercise.type = ExerciseType.mixed.rawValue

            let newExerciseAction1 = ExerciseActionEntity(context: viewContext)
            newExerciseAction1.uuid = UUID()
            newExerciseAction1.name = "Treadmill run"
            newExerciseAction1.duration = Int16(180)
            newExerciseAction1.order = Int16(1)
            newExerciseAction1.type = ExerciseActionType.timed.rawValue
            newSupersetExercise.addToExerciseActions(newExerciseAction1)
            
            let newExerciseAction2 = ExerciseActionEntity(context: viewContext)
            newExerciseAction2.uuid = UUID()
            newExerciseAction2.name = "Deadlift"
            newExerciseAction2.reps = Int16(12)
            newExerciseAction2.sets = Int16(1)
            newExerciseAction2.order = Int16(2)
            newExerciseAction2.type = ExerciseActionType.setsNreps.rawValue
            newExerciseAction2.weightType = WeightType.barbell.rawValue
            newSupersetExercise.addToExerciseActions(newExerciseAction2)
            
            let newExerciseAction3 = ExerciseActionEntity(context: viewContext)
            newExerciseAction3.uuid = UUID()
            newExerciseAction3.name = "Lat Pulldowns"
            newExerciseAction3.repsMax = true
            newExerciseAction3.sets = Int16(1)
            newExerciseAction3.order = Int16(2)
            newExerciseAction3.type = ExerciseActionType.setsNreps.rawValue
            newExerciseAction3.weightType = WeightType.machine.rawValue
            newSupersetExercise.addToExerciseActions(newExerciseAction3)
            
            let newExerciseAction4 = ExerciseActionEntity(context: viewContext)
            newExerciseAction4.uuid = UUID()
            newExerciseAction4.name = "Burpees"
            newExerciseAction4.reps = Int16(5)
            newExerciseAction4.sets = Int16(1)
            newExerciseAction4.order = Int16(2)
            newExerciseAction4.type = ExerciseActionType.setsNreps.rawValue
            newExerciseAction4.weightType = WeightType.body.rawValue
            
            newSupersetExercise.addToExerciseActions(newExerciseAction4)
            workout.addToExercises(newSupersetExercise)
        }

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
