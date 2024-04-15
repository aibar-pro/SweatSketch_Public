//
//  RunningWorkoutViewModel.swift
//  SweatSketch
//
//  Created by aibaranchikov on 02.04.2024.
//

import CoreData

class ActiveWorkoutViewModel: ObservableObject {
    
    let mainContext: NSManagedObjectContext
    
    let activeWorkout: ActiveWorkoutViewRepresentation
    var items = [ActiveWorkoutItemViewRepresentation]()
    @Published var activeItem: ActiveWorkoutItemViewRepresentation?
    
    private let workoutDataManager = WorkoutDataManager()
    
    init(activeWorkoutUUID: UUID, in context: NSManagedObjectContext) throws {
        self.mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.mainContext.parent = context
        
        let workoutRepresentation = try ActiveWorkoutViewRepresentation(workoutUUID: activeWorkoutUUID, in: context)
        
        self.activeWorkout = workoutRepresentation
        self.items = workoutRepresentation.items
        self.activeItem = items.first
    }
    
    func isActiveItem(item: ActiveWorkoutItemViewRepresentation) -> Bool {
        return activeItem == item && activeItem != nil
    }
    
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
//
//    func getExercise(from item: ActiveWorkoutItemRepresentation) -> ExerciseEntity? {
//        guard let exercisesArray = self.activeWorkout?.exercises?.array as? [ExerciseEntity],
//              let exerciseIndex = exercisesArray.firstIndex(where: { $0.uuid == item.id }) else {
//            return nil
//        }
//        return exercisesArray[exerciseIndex]
//    }
//    
//    func getRestTime(from item: ActiveWorkoutItemRepresentation) -> RestTimeEntity? {
//        guard let restTimesArray = self.activeWorkout?.restTimes as? [RestTimeEntity],
//              let restTimeIndex = restTimesArray.firstIndex(where: { $0.uuid == item.id }) else {
//            return nil
//        }
//        return restTimesArray[restTimeIndex]
//    }
//    
//    func fetchActiveWorkoutItems(){        
//        do {
//            if let exercises = self.activeWorkout?.exercises?.array as? [ExerciseEntity] {
//                try exercises.enumerated().forEach({ exercise in
//                    if exercise.element != exercises.first {
//                        if let exerciseRestTime = exercise.element.restTime {
//                            let newItem = try exerciseRestTime.toActiveItemRepresentation()
//                            items.append(newItem)
//                        } else {
//                            let newItem = ActiveWorkoutItemRepresentation(id: UUID(), name: Constants.Placeholders.restPeriodLabel, type: .rest, restTimeDuration: Int32(Constants.DefaultValues.restTimeDuration))
//                            items.append(newItem)
//                        }
//                    }
//                    items.append(try exercise.element.toActiveWorkoutItemRepresentation())
//                })
//            }
//        } catch {
//            
//        }
//    }
                
//                if let exerciseActions = (exercise.element.exerciseActions?.array as? [ExerciseActionEntity])?.filter({!$0.isRestTime}) {
//                    exerciseActions.enumerated().forEach({ action in
//                        if ExerciseActionType.from(rawValue: action.element.type) == .setsNreps || (ExerciseActionType.from(rawValue: action.element.type) == .unknown && ExerciseType.from(rawValue: exercise.element.type) == .setsNreps) {
//                            let newItem = action.element.setNrepsActionToActiveItemRepresentation(name: action.element.name ?? exercise.element.name ?? Constants.Placeholders.noActionName)
//                            items.append(newItem)
//                        }
//                        if ExerciseActionType.from(rawValue: action.element.type) == .timed || (ExerciseActionType.from(rawValue: action.element.type) == .unknown && ExerciseType.from(rawValue: exercise.element.type) == .timed){
//                            let newItem = action.element.timedActionToActiveItemRepresentation(name: action.element.name ?? exercise.element.name ?? Constants.Placeholders.noActionName)
//                            items.append(newItem)
//                        }
//                        if action.element != exerciseActions.last {
//                            if let exerciseRestTime = (exercise.element.exerciseActions?.array as? [ExerciseActionEntity])?.first(where: { $0.isRestTime}) {
//                                let newItem = exerciseRestTime.restTimeToActiveItemRepresentation(name: Constants.Placeholders.restPeriodLabel)
//                                items.append(newItem)
//                            } else {
//                                let newItem = ActiveWorkoutItemRepresentation(name: Constants.Placeholders.restPeriodLabel, type: .rest, duration: defaultWorkoutRestTimeDuration)
//                                items.append(newItem)
//                            }
//                        }
//                    })
//                }
//            })
//        }
//    }
    

}
