//
//  RunningWorkoutViewModel.swift
//  SweatSketch
//
//  Created by aibaranchikov on 02.04.2024.
//

import CoreData

class ActiveWorkoutViewModel: ObservableObject {
    
    let activeWorkoutContext: NSManagedObjectContext
    
    @Published var activeWorkout: WorkoutEntity?
    
    init(context: NSManagedObjectContext, activeWorkoutUUID: UUID) {
        self.activeWorkoutContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.activeWorkoutContext.parent = context
        
        let workoutFetchRequest: NSFetchRequest<WorkoutEntity> = WorkoutEntity.fetchRequest()
        workoutFetchRequest.predicate = NSPredicate(format: "uuid == %@", activeWorkoutUUID as CVarArg)
        do {
            self.activeWorkout = try self.activeWorkoutContext.fetch(workoutFetchRequest).first
        } catch {
            print("Error fetching workout: \(error)")
        }
    }
}
