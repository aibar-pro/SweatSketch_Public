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
    var items = [ActiveWorkoutItemRepresentation]()
    @Published var activeItem: ActiveWorkoutItemRepresentation?
    
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
        
        unwrapWorkout()
        self.activeItem = items.first
//        self.items = self.activeWorkout?.exercises?.array as? [ExerciseEntity] ?? []
//        
//        self.activeItem = self.items?.randomElement()
    }
    
    func isActiveItem(item: ActiveWorkoutItemRepresentation) -> Bool {
        return activeItem == item && activeItem != nil
    }
    
    func unwrapWorkout(){
        var defaultWorkoutRestTimeDuration: Int32
        if let defaultWorkoutRestTime = activeWorkout?.restTimes?.first(where: { restTime in
            (restTime as? RestTimeEntity)?.isDefault == true
        }) as? RestTimeEntity {
            defaultWorkoutRestTimeDuration = defaultWorkoutRestTime.duration
        } else {
            defaultWorkoutRestTimeDuration = Int32(Constants.DefaultValues.restTimeDuration)
        }
        
//        if let workoutRestTimes = (activeWorkout?.restTimes?.allObjects as? [RestTimeEntity])?.filter( { !$0.isDefault} ) {
//
//        }
        
        if let exercises = self.activeWorkout?.exercises?.array as? [ExerciseEntity] {
            exercises.enumerated().forEach({ exercise in
                if exercise.element != exercises.first {
                    if let exerciseRestTime = exercise.element.restTime {
                        let newItem = ActiveWorkoutItemRepresentation(name: Constants.Design.Placeholders.restPeriodLabel, type: .rest, duration: exerciseRestTime.duration)
                        items.append(newItem)
                    } else {
                        let newItem = ActiveWorkoutItemRepresentation(name: Constants.Design.Placeholders.restPeriodLabel, type: .rest, duration: defaultWorkoutRestTimeDuration)
                        items.append(newItem)
                    }
                }
                
                if let exerciseActions = (exercise.element.exerciseActions?.array as? [ExerciseActionEntity])?.filter({!$0.isRestTime}) {
                    exerciseActions.enumerated().forEach({ action in
                        if ExerciseActionType.from(rawValue: action.element.type) == .setsNreps || (ExerciseActionType.from(rawValue: action.element.type) == .unknown && ExerciseType.from(rawValue: exercise.element.type) == .setsNreps) {
                            let newItem = action.element.setNrepsActionToActiveItemRepresentation(name: action.element.name ?? exercise.element.name ?? Constants.Design.Placeholders.noActionName)
                            items.append(newItem)
                        }
                        if ExerciseActionType.from(rawValue: action.element.type) == .timed || (ExerciseActionType.from(rawValue: action.element.type) == .unknown && ExerciseType.from(rawValue: exercise.element.type) == .timed){
                            let newItem = action.element.timedActionToActiveItemRepresentation(name: action.element.name ?? exercise.element.name ?? Constants.Design.Placeholders.noActionName)
                            items.append(newItem)
                        }
                        if action.element != exerciseActions.last {
                            if let exerciseRestTime = (exercise.element.exerciseActions?.array as? [ExerciseActionEntity])?.first(where: { $0.isRestTime}) {
                                let newItem = exerciseRestTime.restTimeToActiveItemRepresentation(name: Constants.Design.Placeholders.restPeriodLabel)
                                items.append(newItem)
                            } else {
                                let newItem = ActiveWorkoutItemRepresentation(name: Constants.Design.Placeholders.restPeriodLabel, type: .rest, duration: defaultWorkoutRestTimeDuration)
                                items.append(newItem)
                            }
                        }
                    })
                }
            })
        }
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
}
