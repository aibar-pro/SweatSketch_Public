//
//  RunningWorkoutViewModel.swift
//  SweatSketch
//
//  Created by aibaranchikov on 02.04.2024.
//

import CoreData

class ActiveWorkoutViewModel: ObservableObject {
    
    let activeWorkoutContext: NSManagedObjectContext
    
    //TODO: Change optional
    @Published var activeWorkout: WorkoutEntity?
    var items = [ActiveWorkoutItemRepresentation]()
    @Published var activeItem: ActiveWorkoutItemRepresentation?
    
    private let workoutDataManager = WorkoutDataManager()
    
    init(context: NSManagedObjectContext, activeWorkoutUUID: UUID) {
        self.activeWorkoutContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.activeWorkoutContext.parent = context
        
        self.activeWorkout = workoutDataManager.fetchWorkout(by: activeWorkoutUUID, in: self.activeWorkoutContext)
        
        fetchActiveWorkoutItems()
        self.activeItem = items.first
    }
    
    func isActiveItem(item: ActiveWorkoutItemRepresentation) -> Bool {
        return activeItem == item && activeItem != nil
    }
    
    func getExercise(from item: ActiveWorkoutItemRepresentation) -> ExerciseEntity? {
        guard let exercisesArray = self.activeWorkout?.exercises?.array as? [ExerciseEntity],
              let exerciseIndex = exercisesArray.firstIndex(where: { $0.uuid == item.id }) else {
            return nil
        }
        return exercisesArray[exerciseIndex]
    }
    
    func getRestTime(from item: ActiveWorkoutItemRepresentation) -> RestTimeEntity? {
        guard let restTimesArray = self.activeWorkout?.restTimes as? [RestTimeEntity],
              let restTimeIndex = restTimesArray.firstIndex(where: { $0.uuid == item.id }) else {
            return nil
        }
        return restTimesArray[restTimeIndex]
    }
    
    func fetchActiveWorkoutItems(){        
        do {
            if let exercises = self.activeWorkout?.exercises?.array as? [ExerciseEntity] {
                try exercises.enumerated().forEach({ exercise in
                    if exercise.element != exercises.first {
                        if let exerciseRestTime = exercise.element.restTime {
                            let newItem = try exerciseRestTime.toActiveItemRepresentation()
                            items.append(newItem)
                        } else {
                            let newItem = ActiveWorkoutItemRepresentation(id: UUID(), name: Constants.Design.Placeholders.restPeriodLabel, type: .rest, restTimeDuration: Int32(Constants.DefaultValues.restTimeDuration))
                            items.append(newItem)
                        }
                    }
                    items.append(try exercise.element.toActiveWorkoutItemRepresentation())
                })
            }
        } catch {
            
        }
    }
                
//                if let exerciseActions = (exercise.element.exerciseActions?.array as? [ExerciseActionEntity])?.filter({!$0.isRestTime}) {
//                    exerciseActions.enumerated().forEach({ action in
//                        if ExerciseActionType.from(rawValue: action.element.type) == .setsNreps || (ExerciseActionType.from(rawValue: action.element.type) == .unknown && ExerciseType.from(rawValue: exercise.element.type) == .setsNreps) {
//                            let newItem = action.element.setNrepsActionToActiveItemRepresentation(name: action.element.name ?? exercise.element.name ?? Constants.Design.Placeholders.noActionName)
//                            items.append(newItem)
//                        }
//                        if ExerciseActionType.from(rawValue: action.element.type) == .timed || (ExerciseActionType.from(rawValue: action.element.type) == .unknown && ExerciseType.from(rawValue: exercise.element.type) == .timed){
//                            let newItem = action.element.timedActionToActiveItemRepresentation(name: action.element.name ?? exercise.element.name ?? Constants.Design.Placeholders.noActionName)
//                            items.append(newItem)
//                        }
//                        if action.element != exerciseActions.last {
//                            if let exerciseRestTime = (exercise.element.exerciseActions?.array as? [ExerciseActionEntity])?.first(where: { $0.isRestTime}) {
//                                let newItem = exerciseRestTime.restTimeToActiveItemRepresentation(name: Constants.Design.Placeholders.restPeriodLabel)
//                                items.append(newItem)
//                            } else {
//                                let newItem = ActiveWorkoutItemRepresentation(name: Constants.Design.Placeholders.restPeriodLabel, type: .rest, duration: defaultWorkoutRestTimeDuration)
//                                items.append(newItem)
//                            }
//                        }
//                    })
//                }
//            })
//        }
//    }
    
    func nextItem() {
        if let activeItem = self.activeItem, let currentIndex = self.items.firstIndex(where: {$0 == activeItem }) {
            let nextIndex = min(currentIndex+1, items.count-1)
            self.activeItem = self.items[nextIndex]
        }
    }
    
    func previousItem() {
        if let activeItem = self.activeItem, let currentIndex = self.items.firstIndex(where: {$0 == activeItem }) {
            let nextIndex = max(currentIndex-1, 0)
            self.activeItem = self.items[nextIndex]
        }
    }
}
