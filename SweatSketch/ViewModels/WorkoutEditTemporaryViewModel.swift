//
//  NewWorkoutModel.swift
//  MyWorkoutPlanner
//
//  Created by aibaranchikov on 29.11.2023.
//

import Foundation
import CoreData

class WorkoutEditTemporaryViewModel: ObservableObject {
    
    private let temporaryContext: NSManagedObjectContext
    var parentViewModel: WorkoutCarouselViewModel
    
    @Published var editingWorkout: WorkoutEntity?
    @Published var exercises: [ExerciseEntity] = []
    
    init(parentViewModel: WorkoutCarouselViewModel, editingWorkout: WorkoutEntity? = nil) {
        self.temporaryContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.temporaryContext.parent = parentViewModel.mainContext
        
        self.parentViewModel = parentViewModel
        
        if editingWorkout != nil {
            let workoutFetchRequest: NSFetchRequest<WorkoutEntity> = WorkoutEntity.fetchRequest()
            workoutFetchRequest.predicate = NSPredicate(format: "SELF == %@", editingWorkout!.objectID)
            do {
                self.editingWorkout = try self.temporaryContext.fetch(workoutFetchRequest).first
            } catch {
                print("Error fetching workout: \(error)")
            }
            self.exercises = self.editingWorkout?.exercises?.array as? [ExerciseEntity] ?? []
        } else {
            addWorkout(name: "New workout")
        }
    }

    func addWorkout(name: String) {
        let newWorkout = WorkoutEntity(context: temporaryContext)
        newWorkout.uuid = UUID()
        newWorkout.name = name
        newWorkout.position = (parentViewModel.workouts.last?.position ?? -1) + 1
        self.editingWorkout = newWorkout
    }

    func renameWorkout(newName: String) {
        self.editingWorkout?.name = newName
    }
    
//    func addExercise(to workout: WorkoutPlan, newExercise: Exercise) {
//        editingWorkout?.addToExercises(newExercise)
//        saveContext()
//    }
//
//
//    func deleteExercise(offsets: IndexSet) {
//
//        offsets.map { editingWorkout?.exercises?.array[$0] as! Exercise }.forEach({
////                editingWorkout?.removeFromExercises($0)
//                temporaryContext.delete($0)
//            })
//        saveContext()
//    }
//
//    func reorderExercise(source: IndexSet, destination: Int) {
//        source.map { editingWorkout?.exercises?.array[$0] as! Exercise }
//            .forEach({
//                editingWorkout?.removeFromExercises($0)
//                // Have to adjust the destination to avoid crush after drag-and-drop at bottom or top of the list
//                var adjustedDestination = destination-1
//                if adjustedDestination < 0 {
//                    adjustedDestination = 0
//                }
//                editingWorkout?.insertIntoExercises($0, at: adjustedDestination)
//            })
//        saveContext()
//    }
//    private func fetchExercises() {
//       temporaryContext.perform {
////           let workoutFetchRequest: NSFetchRequest<WorkoutPlanEntity> = WorkoutPlanEntity.fetchRequest()
////           workoutFetchRequest.predicate = NSPredicate(format: "SELF == %@", self.editingWorkout!.objectID)
////
////           do {
////               let workoutResults = try self.temporaryContext.fetch(workoutFetchRequest)
////               if let workout = workoutResults.first {
////                   // Assuming that `exercises` is a relationship property of `WorkoutEntity`
////                   if let fetchedExercises = workout.exercises as? [ExerciseEntity] {
////                       DispatchQueue.main.async {
////                           self.exercises = fetchedExercises
////                       }
////                   }
////               }
////           } catch {
////               print("Error fetching exercises: \(error)")
////           }
//           let exercisesFetchRequest: NSFetchRequest<ExerciseEntity> = ExerciseEntity.fetchRequest()
//           exercisesFetchRequest.predicate = NSPredicate(format: "%K == %@",
//                                                         #keyPath(ExerciseEntity.workoutPlan), self.editingWorkout!)
//           
//           do {
//               self.exercises = try self.temporaryContext.fetch(exercisesFetchRequest)
//           } catch {
//               print("Error fetching workouts: \(error)")
//           }
//       }
//   }
    
    func addExercise(name: String) {
        let newExercise = ExerciseEntity(context: temporaryContext)
        newExercise.name = name
//        newExercise.workout = editingWorkout
        editingWorkout?.addToExercises(newExercise)
        exercises.append(newExercise)
    }

    func deleteExercise(at offsets: IndexSet) {
        //        offsets.forEach { index in
        //            let exercise = exercises[index]
        //            temporaryContext.delete(exercise)
        //        }
        //    }
        temporaryContext.perform {
            let exercisesToDelete = offsets.map { self.exercises[$0] }
            exercisesToDelete.forEach { exercise in
                self.temporaryContext.delete(exercise)
            }
            do {
                try self.temporaryContext.save()
                DispatchQueue.main.async {
                    self.exercises.remove(atOffsets: offsets)
                }
            } catch {
                print("Error deleting exercises: \(error)")
            }
        }
    }
    

    func reorderExercise(from source: IndexSet, to destination: Int) {
        exercises.move(fromOffsets: source, toOffset: destination)
    }
    
    func saveExercise() {
        exercises.enumerated().forEach{ index, exercise in
            editingWorkout?.removeFromExercises(exercise)
            editingWorkout?.insertIntoExercises(exercise, at: index)
        }
    }
    
    func saveWorkout() {
        do {
            saveExercise()
            saveContext()
            try temporaryContext.parent?.save()
            parentViewModel.refreshData()
        } catch {
            print("Error saving context: \(error)")
        }
    }

    private func saveContext() {
        do {
            try temporaryContext.save()
            print("Context saved \(editingWorkout?.uuid)")
            print("New Workout \(parentViewModel.workouts.count)")
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func cancelWorkoutEdit() {
        temporaryContext.rollback()
    }
}
