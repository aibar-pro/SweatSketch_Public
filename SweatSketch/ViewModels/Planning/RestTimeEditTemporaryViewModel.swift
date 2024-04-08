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

    @Published var editingWorkout: WorkoutEntity
    @Published var exercises: [ExerciseEntity] = []
    @Published var defaultRestTime: RestTimeEntity?
    @Published var editingRestTime: RestTimeEntity?
    var isNewRestTime: Bool = false
    
    let workoutDataManager = WorkoutDataManager()
    
    init(parentViewModel: WorkoutEditTemporaryViewModel) {
        self.parentViewModel = parentViewModel
        self.temporaryRestTimeContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        self.temporaryRestTimeContext.parent = parentViewModel.mainContext
        
        self.editingWorkout = WorkoutEntity()
        self.exercises = []
        
        if let workoutToEdit = workoutDataManager.fetchWorkout(workout: parentViewModel.editingWorkout, in: self.temporaryRestTimeContext) {
            
            self.editingWorkout = workoutToEdit
            
            self.exercises = workoutDataManager.fetchExercises(for: workoutToEdit, in: self.temporaryRestTimeContext)
            
            self.defaultRestTime = workoutToEdit.restTimes?.first { restTime in
                (restTime as? RestTimeEntity)?.isDefault == true
            } as? RestTimeEntity
        }
    }
    
    func addRestTime(for exercise: ExerciseEntity) {
        let newRestTime = RestTimeEntity(context: temporaryRestTimeContext)
        newRestTime.uuid = UUID()
        newRestTime.isDefault = false
        newRestTime.followingExercise = exercise
        newRestTime.duration = defaultRestTime?.duration ?? Int32(Constants.DefaultValues.restTimeDuration)
        editingWorkout.addToRestTimes(newRestTime)
        self.editingRestTime = newRestTime
        isNewRestTime = true
    }
    
    func deleteRestTime(for exercise: ExerciseEntity) {
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
    

    func discardRestTime(for exercise: ExerciseEntity) {
        if isNewRestTime {
            deleteRestTime(for: exercise)
            isNewRestTime = false
        }
    }
    

    func setEditingRestTime(for exercise: ExerciseEntity) {
        if let exerciseRestTime = exercise.restTime {
            editingRestTime = exerciseRestTime
        } else {
            addRestTime(for: exercise)
        }
    }

    func clearEditingRestTime() {
        editingRestTime = nil
        isNewRestTime = false
    }
    
    func isEditingRestTime(for exercise: ExerciseEntity) -> Bool {
        editingRestTime?.followingExercise == exercise && editingRestTime == exercise.restTime && exercise.restTime != nil
    }
    
    func saveRestTime() {
        do {
            try temporaryRestTimeContext.save()
            parentViewModel.objectWillChange.send()
        } catch {
            print("Error saving exercise temporary context: \(error)")
        }
    }
    
    func cancelRestTime() {
        temporaryRestTimeContext.rollback()
    }
}
