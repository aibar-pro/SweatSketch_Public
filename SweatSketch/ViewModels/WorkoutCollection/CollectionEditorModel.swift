//
//  CollectionEditorModel.swift
//  SweatSketch
//
//  Created by aibaranchikov on 13.03.2024.
//

import CoreData

class CollectionEditorModel: ObservableObject {

    private let context: NSManagedObjectContext
    private let parent: WorkoutCollectionViewModel
    
    let collection: WorkoutCollectionEntity
    @Published var workouts: [WorkoutRepresentation] = []
    
    private let collectionDataManager = CollectionDataManager()
    private let workoutDataManager = WorkoutDataManager()
    
    var canUndo: Bool {
        return context.undoManager?.canUndo ?? false
    }
    var canRedo: Bool {
       return context.undoManager?.canRedo ?? false
    }
    
    init(parent: WorkoutCollectionViewModel, workoutCollection: WorkoutCollectionEntity) {
        self.context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.context.parent = parent.context
        self.parent = parent
        
        if self.context.undoManager == nil {
            self.context.undoManager = UndoManager()
        }
        self.context.undoManager?.levelsOfUndo = Constants.Data.undoLevelsLimit
        
        self.collection = workoutCollection
        
        reloadWorkouts()
    }
    
    func saveWorkoutListChange() {
        do {
            try context.save()
            parent.saveContext()
        } catch {
            print("Error saving workout main context: \(error)")
        }
        parent.refreshData()
    }

    func discardWorkoutListChange() {
        context.rollback()
    }

    func moveWorkouts(from source: IndexSet, to destination: Int) {
        workouts.move(fromOffsets: source, toOffset: destination)
        
        context.undoManager?.beginUndoGrouping()
        defer { context.undoManager?.endUndoGrouping() }
        
        let positions = Dictionary(
            uniqueKeysWithValues: workouts.enumerated().map { idx, repr in
                (repr.id, idx)
            }
        )
        positions.forEach { idx, pos in
            if let workout = workoutDataManager.fetchWorkout(by: idx, in: context) {
                context.undoManager?.registerUndo(
                    withTarget: self,
                    selector: #selector(undoWorkoutMove(_ :)),
                    object: workout
                )
            }
        }
        collectionDataManager.updateWorkoutPositions(positions, for: collection, in: context)
    }
    
    func deleteWorkouts(at offsets: IndexSet) {
        context.undoManager?.beginUndoGrouping()
        defer { context.undoManager?.endUndoGrouping() }
        
        let toDelete = offsets.map { workouts[$0].id }
        toDelete.forEach { id in
            if let workout = workoutDataManager.fetchWorkout(by: id, in: context) {
                context.undoManager?.registerUndo(
                    withTarget: self,
                    selector: #selector(undoWorkoutDelete(_ :)),
                    object: workout
                )
            }
            workoutDataManager.removeWorkout(with: id, in: context)
        }
        
        workouts.remove(atOffsets: offsets)
    }
    
    @objc func undoWorkoutDelete(_ workout: WorkoutEntity) {
        context.undoManager?.beginUndoGrouping()
        defer { context.undoManager?.endUndoGrouping() }
        
        context.undoManager?.registerUndo(
            withTarget: self,
            selector: #selector(redoWorkoutDelete(_ :)),
            object: workout
        )
        reloadWorkouts()
    }
    
    @objc func redoWorkoutDelete(_ workout: WorkoutEntity) {
        context.undoManager?.beginUndoGrouping()
        defer { context.undoManager?.endUndoGrouping() }
        
        guard let uuid = workout.uuid else { return }
        context.undoManager?.registerUndo(
            withTarget: self,
            selector: #selector(undoWorkoutDelete(_ :)),
            object: workout
        )
        workoutDataManager.removeWorkout(with: uuid, in: context)
        reloadWorkouts()
    }
    
    //TODO: Fix. In rare cases the list freezes
    @objc func undoWorkoutMove(_ workout: WorkoutEntity) {
        context.undoManager?.beginUndoGrouping()
        defer { context.undoManager?.endUndoGrouping() }
        
        context.undoManager?.registerUndo(
            withTarget: self,
            selector: #selector(undoWorkoutMove(_ :)),
            object: workout
        )
        reloadWorkouts()
    }
    
    func reloadWorkouts() {
//        do {
            self.workouts = collectionDataManager
                .fetchWorkouts(for: collection, in: context)
                .compactMap { $0.toWorkoutRepresentation(includeContent: false) }
//        } catch {
//            print("\(type(of: self)): \(#function): Error fetching exercises: \(error)")
//        }
    }
    

    func undo() {
        context.undoManager?.undo()
        self.objectWillChange.send()
    }
        
    func redo() {
        context.undoManager?.redo()
        self.objectWillChange.send()
    }
}
