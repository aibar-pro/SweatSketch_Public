//
//  WorkoutListTemporaryViewModel.swift
//  SweatSketch
//
//  Created by aibaranchikov on 13.03.2024.
//

import Foundation
import CoreData

class WorkoutListTemporaryViewModel: ObservableObject {
    
    private let temporaryWorkoutListContext: NSManagedObjectContext
    let parentViewModel: WorkoutCarouselViewModel
    
    @Published var workouts = [WorkoutEntity]()
    
    init(parentViewModel: WorkoutCarouselViewModel) {
        self.temporaryWorkoutListContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.temporaryWorkoutListContext.parent = parentViewModel.mainContext
        self.parentViewModel = parentViewModel
        
        fetchWorkouts()
    }
    
    private func fetchWorkouts() {
        let request: NSFetchRequest<WorkoutEntity> = WorkoutEntity.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "position", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            workouts = try temporaryWorkoutListContext.fetch(request)
        } catch {
            print("Error fetching workouts for temporary ViewModel: \(error)")
        }
    }
    
    func saveWorkoutListChange() {
        saveTemporaryListContext()
        parentViewModel.refreshData()
    }

    func discardWorkoutListChange() {
        temporaryWorkoutListContext.rollback()
    }
    
    private func saveTemporaryListContext() {
        do {
            try temporaryWorkoutListContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func deleteWorkout(offsets: IndexSet) {
        let workoutsToDelete = offsets.map { self.workouts[$0] }
        workoutsToDelete.forEach { workout in
            self.workouts.remove(atOffsets: offsets)
            self.temporaryWorkoutListContext.delete(workout)
        }
    }

    func moveWorkout(source: IndexSet, destination: Int) {
        workouts.move(fromOffsets: source, toOffset: destination)
        
        workouts.enumerated().forEach{ index, workout in
            workout.position = Int16(index)
        }
    }
}
