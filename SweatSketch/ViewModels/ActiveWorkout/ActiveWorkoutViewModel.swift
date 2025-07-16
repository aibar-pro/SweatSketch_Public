//
//  RunningWorkoutViewModel.swift
//  SweatSketch
//
//  Created by aibaranchikov on 02.04.2024.
//

import CoreData
import Combine
import ActivityKit
import SwiftUI


//TODO: Add workout finished live activity state
class ActiveWorkoutViewModel: ObservableObject, ActiveWorkoutManagementProtocol {
    @Published private(set) var items: [ActiveWorkoutItem] = []
    @Published private(set) var currentItemIndex: Int = 0
    @Published private(set) var itemProgress: ItemProgress = .init()
    var progressBinding: Binding<ItemProgress> {
        .init(get: { self.itemProgress }, set: { _ in })
    }
    
    @Published private(set) var remainingActionDuration: Int = 0
    @Published private(set) var totalWorkoutDuration: Int = 0

    var currentItem: ActiveWorkoutItem? {
        items[safe: currentItemIndex]
    }
    
    var currentAction: ActionRepresentation? {
        currentItem?.actions[safe: itemProgress.stepIndex]
    }
    
    func isCurrentItem(_ item: ActiveWorkoutItem) -> Bool {
        return currentItem == item && currentItem != nil
    }
    
    var isLastStep: Bool {
        guard let item = currentItem else { return true }
        return currentItemIndex == items.count - 1
            && itemProgress.stepIndex == item.actions.count - 1
    }
    
    private var actionTimer:  AnyCancellable?
    private var workoutTimer: AnyCancellable?
    
    //"Stored properties cannot be marked potentially unavailable with '@available'"
    private var liveActivity: Any?
    
    private let context: NSManagedObjectContext
    private var cancellables = Set<AnyCancellable>()
    
    let workoutName: String
    
    init(activeWorkoutUUID: UUID, in context: NSManagedObjectContext) throws {
        self.context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.context.parent = context
        
        let workoutDataManager = WorkoutDataManager()
        guard let workout = workoutDataManager.fetchWorkout(by: activeWorkoutUUID, in: context) else {
            throw ActiveWorkoutError.invalidWorkoutUUID
        }
        self.workoutName = workout.name ?? Constants.Placeholders.noWorkoutName
        
        self.items = Self.buildItems(for: workout, in: context)
        guard !items.isEmpty else {
            throw ActiveWorkoutError.emptyWorkout
        }
        
        resetCurrentItemProgress()
    }
    
    func startWorkout() {
        startWorkoutTimer()
        handleActionTimerIfNeeded()
        startLiveActivityIfPossible()
    }
    
    //MARK: - Item navigation
    func next() {
        guard let item = currentItem else { return }
        
        if itemProgress.stepIndex < item.actions.count - 1 {
            itemProgress.stepIndex += 1
        } else if currentItemIndex < items.count - 1 {
            currentItemIndex += 1
            resetCurrentItemProgress()
        }
        transitionToNewPosition()
    }
    
    func previous() {
        if itemProgress.stepIndex > 0 {
            itemProgress.stepIndex -= 1
        } else if currentItemIndex > 0 {
            currentItemIndex -= 1
            guard let newItem = currentItem else { return }
            itemProgress.reset(
                stepIndex: newItem.actions.count - 1,
                totalSteps: newItem.actions.count,
                quantity: newItem.actions.last?.type.description(includeSets: false) ?? ""
            )
        }
        transitionToNewPosition()
    }
    
    private func transitionToNewPosition() {
        resetActionTimer()
        resetCurrentStepProgress()
        handleActionTimerIfNeeded()
        updateLiveActivity()
    }
    
    private func resetCurrentStepProgress() {
        guard let act = currentAction else { return }
        
        itemProgress.update(
            quantity: act.type.description(includeSets: false),
            progress: 0
        )
    }
    
    private func resetCurrentItemProgress() {
        guard let item = currentItem,
                let first = item.actions.first
        else { return }
        
        itemProgress.reset(
            stepIndex: 0,
            totalSteps: item.actions.count,
            quantity: first.type.description(includeSets: false)
        )
    }
    
    //MARK: - Timers
    
    func startWorkoutTimer() {
        workoutTimer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in self?.totalWorkoutDuration += 1 }
    }
    
    func stopWorkoutTimer() {
        workoutTimer?.cancel()
    }
    
    private func handleActionTimerIfNeeded() {
        switch currentAction?.type {
        case .rest(let seconds):
            if seconds > 0 { startActionCountdown(totalSeconds: seconds) }
        case .timed(_, let min, let max, let isMax):
            if !isMax && max == nil { startActionCountdown(totalSeconds: min) }
        default: break
        }
        guard case .rest(let seconds)? = currentAction?.type else { return }
        startActionCountdown(totalSeconds: seconds)
    }
    
    private func startActionCountdown(totalSeconds: Int) {
        remainingActionDuration = totalSeconds
        publishActionTick(total: totalSeconds, remaining: totalSeconds)
        
        actionTimer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                remainingActionDuration -= 1
                publishActionTick(
                    total: totalSeconds,
                    remaining: remainingActionDuration
                )
                
                if remainingActionDuration <= 0 { resetActionTimer() }
            }
    }

    private func resetActionTimer() {
        actionTimer?.cancel()
        actionTimer = nil
        remainingActionDuration = 0
    }
    
    private func publishActionTick(total: Int, remaining: Int) {
        guard remaining >= 0 else { return }
        let elapsed  = total - remaining
        let progress = Double(elapsed) / Double(max(total, 1))
        itemProgress.update(
            quantity: remaining.formattedTime(components: 3),
            progress: progress
        )
        updateLiveActivity()
    }
    
    //MARK: - Live Activity
    
    private func startLiveActivityIfPossible() {
        guard #available(iOS 16.1, *), liveActivity == nil else { return }
        do {
            liveActivity = try Activity<ActiveWorkoutActionAttributes>.request(
                attributes: .init(),
                contentState: liveContentState(),
                pushType: nil
            )
        } catch {
            print("\(type(of: self)): Failed to launch Live Activity – \(error)")
        }
    }

    private func updateLiveActivity() {
        guard #available(iOS 16.1, *) else { return }
        Task { @MainActor in
            await (liveActivity as? Activity<ActiveWorkoutActionAttributes>)?
                .update(using: liveContentState())
        }
    }

    func endLiveActivity() async {
        guard #available(iOS 16.1, *) else { return }
        await (liveActivity as? Activity<ActiveWorkoutActionAttributes>)?.end(dismissalPolicy: .immediate)
        liveActivity = nil
    }

    @available(iOS 16.1, *)
    private func liveContentState() -> ActiveWorkoutActivityState {
        ActiveWorkoutActivityState(
            actionID: currentAction?.id,
            title: currentAction?.title ?? "",
            quantity: itemProgress.stepProgress.quantity,
            itemProgress: itemProgress,
            isRest: { if case .rest = currentAction?.type { return true }; return false }()
        )
    }

    func nextWorkoutStep() {
        Just(())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.next()
            }
            .store(in: &cancellables)
    }
    
    func previousWorkoutStep() {
        Just(())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.previous()
            }
            .store(in: &cancellables)
    }

    private static func buildItems(for workout: WorkoutEntity, in context: NSManagedObjectContext) -> [ActiveWorkoutItem] {
        guard case .success(let exercises) = WorkoutDataManager().fetchExercises(for: workout, in: context) else { return [] }
        var flow: [ActiveWorkoutItem] = []
        for (idx, ex) in exercises.enumerated() {
            if idx > 0 {
                let dur = {
                    if let customRest = exercises[safe: idx - 1]?.postRest?.intValue, customRest > 0 { return customRest }
                    return workout.defaultRest.int
                }()
                print("\(type(of: self)): Rest for \(ex.name ?? "Unknown Exercise"), duration: \(dur), \(workout.defaultRest.int)")
                if let rest = ActiveWorkoutItem(restTime: dur) { flow.append(rest) }
            }
            if let item = ex.toActiveWorkoutItem(defaultRest: workout.defaultRest.int) { flow.append(item) }
        }
        return flow
    }
}
