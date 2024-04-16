//
//  RunningWorkoutViewModel.swift
//  SweatSketch
//
//  Created by aibaranchikov on 02.04.2024.
//

import CoreData
import Combine

class ActiveWorkoutViewModel: ObservableObject {
    
    let mainContext: NSManagedObjectContext
    
    let activeWorkout: ActiveWorkoutViewRepresentation
    var items = [ActiveWorkoutItemViewRepresentation]()
    @Published var activeItem: ActiveWorkoutItemViewRepresentation?
    
    private let workoutDataManager = WorkoutDataManager()
    
    @Published var workoutDuration: Int = 0
    var cancellables: Set<AnyCancellable> = []
    
    init(activeWorkoutUUID: UUID, in context: NSManagedObjectContext) throws {
        self.mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.mainContext.parent = context
        
        let workoutRepresentation = try ActiveWorkoutViewRepresentation(workoutUUID: activeWorkoutUUID, in: context)
        
        self.activeWorkout = workoutRepresentation
        self.items = workoutRepresentation.items
        self.activeItem = items.first
    }
    
    func startTimer(){
//        Timer.publish(every: 1, on: .main, in: .common)
//           .autoconnect()
//           .sink { [weak self] _ in
//               guard let self = self else { return }
//               
//               self.workoutDuration += 1
//           }
//           .store(in: &cancellables)
    }
    
    func cancelTimer() {
//        cancellables.forEach { $0.cancel() }
//        cancellables.removeAll()
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
}
