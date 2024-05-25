//
//  RunningWorkoutViewModel.swift
//  SweatSketch
//
//  Created by aibaranchikov on 02.04.2024.
//

import CoreData
import Combine
import ActivityKit

class ActiveWorkoutViewModel: ObservableObject, ActiveWorkoutManagementProtocol {
    
    let mainContext: NSManagedObjectContext
    
    let activeWorkout: ActiveWorkoutRepresentation
    
    var items = [ActiveWorkoutItemRepresentation]()
    @Published var currentItem: ActiveWorkoutItemRepresentation?
    @Published var currentAction: ActiveWorkoutActionRepresentation?
    @Published var currentProgress: (current: Int, total: Int) = (0, 0)
    @Published var isLastAction: Bool = false

    private let workoutDataManager = WorkoutDataManager()

    var totalWorkoutDuration: Int = 0
    private var workoutTimer: AnyCancellable?
    private var timerIsActive = false
    
    //"Stored properties cannot be marked potentially unavailable with '@available'"
    private var currentActivity: Any?
    
    init(activeWorkoutUUID: UUID, in context: NSManagedObjectContext) throws {
        self.mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.mainContext.parent = context
        
        let workoutRepresentation = try ActiveWorkoutRepresentation(workoutUUID: activeWorkoutUUID, in: context)
        
        self.activeWorkout = workoutRepresentation
        self.items = workoutRepresentation.items
        self.currentItem = workoutRepresentation.currentItem
        self.currentAction = activeWorkout.currentAction
        self.currentProgress = activeWorkout.currentItemProgress()
        self.isLastAction = activeWorkout.isLastAction()
    }
    
    func isCurrentItem(item: ActiveWorkoutItemRepresentation) -> Bool {
        return currentItem == item && currentItem != nil
    }
    
    func nextActiveWorkoutItem() {
        activeWorkout.next()
        currentItem = activeWorkout.currentItem
        currentAction = activeWorkout.currentAction
        currentProgress = activeWorkout.currentItemProgress()
        Task {
            await updateActivityContent(
                ActiveWorkoutActionAttributes.ActiveWorkoutActionStatus(
                    title: currentAction?.title ?? currentItem?.title ?? Constants.Placeholders.noActionName,
                    duration: Int(currentAction?.duration ?? 0),
                    totalActions: currentProgress.total,
                    currentAction: currentProgress.current))
        }
    }
    
    func previousActiveWorkoutItem() {
        activeWorkout.previous()
        currentItem = activeWorkout.currentItem
        currentAction = activeWorkout.currentAction
        currentProgress = activeWorkout.currentItemProgress()
        Task {
            await updateActivityContent(
                ActiveWorkoutActionAttributes.ActiveWorkoutActionStatus(
                    title: currentAction?.title ?? currentItem?.title ?? Constants.Placeholders.noActionName,
                    duration: Int(currentAction?.duration ?? 0),
                    totalActions: currentProgress.total,
                    currentAction: currentProgress.current)
                )
        }
    }
    
    func startActivity() {
        if #available(iOS 16.1, *) {
            let initialContent = ActiveWorkoutActionAttributes.ActiveWorkoutActionStatus(
                title: currentAction?.title ?? currentItem?.title ?? Constants.Placeholders.noActionName,
                duration: Int(currentAction?.duration ?? 0),
                totalActions: currentProgress.total,
                currentAction: currentProgress.current
            )
            do {
                let activity = try Activity<ActiveWorkoutActionAttributes>.request(attributes: ActiveWorkoutActionAttributes(), contentState: initialContent, pushType: nil)
                self.currentActivity = activity
            } catch {
                print("Error starting activity: \(error)")
            }
        } else {
            print("Live Activities are not supported in this iOS version.")
        }
    }
    
    func updateActivityContent(_ content: ActiveWorkoutActionAttributes.ActiveWorkoutActionStatus) async {
        if #available(iOS 16.1, *) {
            await (currentActivity as? Activity<ActiveWorkoutActionAttributes>)?.update(using: content)
        }
    }
    
    func endActivity() async {
        if #available(iOS 16.1, *) {
            await (currentActivity as? Activity<ActiveWorkoutActionAttributes>)?.end(dismissalPolicy: .immediate)
            currentActivity = nil
        }
    }
    
    func startTimer(){
        timerIsActive = true
        workoutTimer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self, self.timerIsActive else { return }
                self.totalWorkoutDuration += 1
            }
    }
    
    func stopTimer() {
        timerIsActive = false
        workoutTimer?.cancel()
    }
}
