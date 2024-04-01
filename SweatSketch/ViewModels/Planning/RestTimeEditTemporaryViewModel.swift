//
//  WorkoutRestTimeEditTemporaryViewModel.swift
//  SweatSketch
//
//  Created by aibaranchikov on 30.03.2024.
//

import Foundation
import CoreData

class RestTimeEditTemporaryViewModel: ObservableObject {
    private let parentViewModel: WorkoutEditTemporaryViewModel
    private let temporaryRestTimeContext: NSManagedObjectContext
    var canUndo: Bool {
        return temporaryRestTimeContext.undoManager?.canUndo ?? false
    }
    var canRedo: Bool {
        return temporaryRestTimeContext.undoManager?.canRedo ?? false
    }
    @Published var editingWorkout: WorkoutEntity?
    @Published var exercises: [ExerciseEntity] = []
    @Published var defaultRestTime: RestTimeEntity?
    @Published var restTimes: [RestTimeEntity]?
    @Published var editingRestTime: RestTimeEntity?
    var isNewRestTime: Bool = false
    
    init(parentViewModel: WorkoutEditTemporaryViewModel) {
        self.parentViewModel = parentViewModel
        self.temporaryRestTimeContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        self.temporaryRestTimeContext.parent = parentViewModel.temporaryWorkoutContext
        
        if let parentWorkout = parentViewModel.editingWorkout {
            let workoutFetchRequest: NSFetchRequest<WorkoutEntity> = WorkoutEntity.fetchRequest()
            workoutFetchRequest.predicate = NSPredicate(format: "SELF == %@", parentWorkout.objectID)
            
            do {
                self.editingWorkout = try self.temporaryRestTimeContext.fetch(workoutFetchRequest).first
            } catch {
                print("Error fetching exercise for temporary context: \(error)")
            }
            
            self.exercises = self.editingWorkout?.exercises?.array as? [ExerciseEntity] ?? []
            
            self.defaultRestTime = editingWorkout?.restTimes?.first { restTime in
                (restTime as? RestTimeEntity)?.isDefault == true
            } as? RestTimeEntity
            
            self.restTimes = (self.editingWorkout?.restTimes?.allObjects as? [RestTimeEntity])?.filter( { !$0.isDefault} )
        }
    }
    
    func addRestTime(for exercise: ExerciseEntity) {
        let newRestTime = RestTimeEntity(context: temporaryRestTimeContext)
        newRestTime.uuid = UUID()
        newRestTime.isDefault = false
        newRestTime.followingExercise = exercise
        newRestTime.duration = defaultRestTime?.duration ?? Int32(Constants.DefaultValues.restTimeDuration)
        editingWorkout?.addToRestTimes(newRestTime)
        self.editingRestTime = newRestTime
    }
    
    func removeRestTime(for exercise: ExerciseEntity) {
        if let restTimeToDelete = exercise.restTime {
            exercise.restTime = nil
            self.temporaryRestTimeContext.delete(restTimeToDelete)
            self.objectWillChange.send()
        }
    }
    
    func updateRestTime(for exercise: ExerciseEntity, duration: Int) {
        if let restTimeToUpdate = exercise.restTime {
            restTimeToUpdate.duration = Int32(duration)
        }
    }
    
    func setEditingRestTime(for exercise: ExerciseEntity) {
        if let exerciseRestTime = exercise.restTime {
            editingRestTime = exerciseRestTime
        } else {
            addRestTime(for: exercise)
            isNewRestTime = true
        }
    }

    func clearEditingRestTime() {
        editingRestTime = nil
        isNewRestTime = false
    }
    
    func isEditingRestTime(for exercise: ExerciseEntity) -> Bool {
        editingRestTime?.followingExercise == exercise
    }
    
    func saveRestTime() {
        do {
            try temporaryRestTimeContext.save()
            parentViewModel.objectWillChange.send()
        } catch {
            print("Error saving exercise temporary context: \(error)")
        }
    }
    
    func discardRestTime() {
        temporaryRestTimeContext.rollback()
    }
}
