//
//  WorkoutRestTimeEditTemporaryViewModel.swift
//  SweatSketch
//
//  Created by aibaranchikov on 30.03.2024.
//

import CoreData

class RestTimeEditViewModel: ObservableObject {
    private let parentViewModel: WorkoutEditorModel
    private let mainContext: NSManagedObjectContext

    @Published var editingWorkout: WorkoutEntity
    @Published var exercises = [ExerciseEntity]()
    @Published var defaultRestTime: RestTimeEntity?
    @Published var editingRestTime: RestTimeEntity?
    var isNewRestTime: Bool = false
    
    let workoutDataManager = WorkoutDataManager()
    
    init?(parentViewModel: WorkoutEditorModel) {
        self.parentViewModel = parentViewModel
        self.mainContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        self.mainContext.parent = parentViewModel.context

        guard let fetchedWorkout = workoutDataManager.fetchWorkout(workout: parentViewModel.workout, in: self.mainContext),
              case .success(let fetchedExercises) = workoutDataManager.fetchExercises(for: fetchedWorkout, in: self.mainContext)
        else {
            return nil
        }
        
        self.editingWorkout = fetchedWorkout
        self.exercises = fetchedExercises
        
        self.defaultRestTime = workoutDataManager.fetchDefaultRestTime(for: fetchedWorkout, in: self.mainContext)
    }
    
    func getRestTime(for exercise: ExerciseEntity) -> RestTimeEntity? {
        return workoutDataManager.fetchRestTime(for: exercise, in: mainContext)
    }
    
    func addRestTime(for exercise: ExerciseEntity, with duration: Int) {
        let result = workoutDataManager.createRestTime(workout: editingWorkout, for: exercise, with: duration, in: mainContext)
        
        if case .success(let restTime) = result {
            self.editingRestTime = restTime
            isNewRestTime = true
        }
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
            restTimeToUpdate.duration = duration.int32
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
            let newRestTimeDuration = defaultRestTime?.duration.int ?? Constants.DefaultValues.restTimeDuration
            addRestTime(for: exercise, with: newRestTimeDuration)
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
