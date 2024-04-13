//
//  WorkoutRestTimeEditTemporaryViewModel.swift
//  SweatSketch
//
//  Created by aibaranchikov on 30.03.2024.
//

import CoreData

class RestTimeEditViewModel: ObservableObject {
    private let parentViewModel: WorkoutEditViewModel
    private let mainContext: NSManagedObjectContext

    @Published var editingWorkout: WorkoutEntity
    @Published var exercises = [ExerciseEntity]()
    @Published var defaultRestTime: RestTimeEntity?
    @Published var editingRestTime: RestTimeEntity?
    var isNewRestTime: Bool = false
    
    let workoutDataManager = WorkoutDataManager()
    
    init(parentViewModel: WorkoutEditViewModel) {
        self.parentViewModel = parentViewModel
        self.mainContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        self.mainContext.parent = parentViewModel.mainContext
        
        self.editingWorkout = WorkoutEntity()
        self.exercises = []
        
        if let workoutToEdit = workoutDataManager.fetchWorkout(workout: parentViewModel.editingWorkout, in: self.mainContext) {
            
            self.editingWorkout = workoutToEdit
            
            self.exercises = workoutDataManager.fetchExercises(for: workoutToEdit, in: self.mainContext)
            
            self.defaultRestTime = workoutDataManager.fetchDefaultRestTime(for: workoutToEdit, in: self.mainContext)
        }
    }
    
    func getRestTime(for exercise: ExerciseEntity) -> RestTimeEntity? {
        return workoutDataManager.fetchRestTime(for: exercise, in: mainContext)
    }
    
    func addRestTime(for exercise: ExerciseEntity, with duration: Int) {
        self.editingRestTime = workoutDataManager.createRestTime(for: exercise, with: duration, in: mainContext)
        isNewRestTime = true
    }
    
    func deleteRestTime(for exercise: ExerciseEntity) {
        if let restTimeToDelete = exercise.restTime {
            exercise.restTime = nil
            self.mainContext.delete(restTimeToDelete)
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
        if let exerciseRestTime = getRestTime(for: exercise) {
            editingRestTime = exerciseRestTime
        } else {
            let newRestTimeDuration = defaultRestTime?.duration ?? Int32(Constants.DefaultValues.restTimeDuration)
            addRestTime(for: exercise, with: Int(newRestTimeDuration))
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
            try mainContext.save()
//            parentViewModel.objectWillChange.send()
        } catch {
            print("Error saving exercise temporary context: \(error)")
        }
    }
    
    func cancelRestTime() {
        mainContext.rollback()
    }
}
