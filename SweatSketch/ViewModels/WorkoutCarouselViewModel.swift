//
//  WorkoutPlanViewModel.swift
//  MyWorkoutPlanner
//
//  Created by aibaranchikov on 28.11.2023.
//

import Foundation
import CoreData

class WorkoutCarouselViewModel: ObservableObject {
    
    @Published var workouts = [WorkoutEntity]()
    let mainContext: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.mainContext = context
        fetchWorkouts()
    }

    private func fetchWorkouts() {
        let request: NSFetchRequest<WorkoutEntity> = WorkoutEntity.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "position", ascending: true)
           request.sortDescriptors = [sortDescriptor]
        
        do {
            workouts = try mainContext.fetch(request)
        } catch {
            print("Error fetching workouts: \(error)")
        }
    }

    func refreshData() {
//        DispatchQueue.main.async {
            self.fetchWorkouts()
//       }
        print("Refresh Workout data. New count: \(workouts.count)")
    }
    
    
    private func saveContext() {
        do {
            try mainContext.save()
            fetchWorkouts()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

}

