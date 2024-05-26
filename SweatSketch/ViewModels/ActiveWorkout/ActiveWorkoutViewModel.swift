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
    
    private var cancellables = Set<AnyCancellable>()
    
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
        Just(())
            .receive(on: DispatchQueue.global(qos: .userInitiated))
            .map { [weak self] _ in
                self?.activeWorkout.next()
                return self
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateCurrentItem()
            }
            .store(in: &cancellables)
    }
    
    func previousActiveWorkoutItem() {
        Just(())
            .receive(on: DispatchQueue.global(qos: .userInitiated))
            .map { [weak self] _ in
                self?.activeWorkout.previous()
                return self
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateCurrentItem()
            }
            .store(in: &cancellables)
    }
    
    func startActivity() {
        guard let currentAction = self.currentAction else {return}
        
        if #available(iOS 16.1, *) {
            let initialContent = ActiveWorkoutActionAttributes.ActiveWorkoutActionStatus(
                action: currentAction,
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
    
    private func updateCurrentItem() {
        self.currentItem = self.activeWorkout.currentItem
        self.currentAction = self.activeWorkout.currentAction
        self.currentProgress = self.activeWorkout.currentItemProgress()
        self.isLastAction = self.activeWorkout.isLastAction()
        
        guard let currentAction = self.currentAction else {return}
        
        Task {
            await self.updateActivityContent(
                ActiveWorkoutActionAttributes.ActiveWorkoutActionStatus(
                    action: currentAction,
                    totalActions: self.currentProgress.total,
                    currentAction: self.currentProgress.current
                )
            )
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
