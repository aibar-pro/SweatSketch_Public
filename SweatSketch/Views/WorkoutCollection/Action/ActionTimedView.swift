//
//  ActionTimedView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 26.03.2024.
//

import SwiftUI

struct ActionTimedView: View {
    
    var action: ExerciseActionViewRepresentation
    
    var showTitle: Bool = false
    
    var body: some View {
        HStack (alignment: .top) {
            if showTitle {
                Text("\(action.name),")
            }
            DurationView(durationInSeconds: Int(action.duration))
        }
    }
}

struct ActionTimedView_Preview : PreviewProvider {

    static var previews: some View {
        let persistenceController = PersistenceController.preview
        
        let collectionDataManager = CollectionDataManager()
        let firstCollection = collectionDataManager.fetchFirstUserCollection(in: persistenceController.container.viewContext)!
        let workoutForPreview = collectionDataManager.fetchWorkouts(for: firstCollection, in: persistenceController.container.viewContext).first!
        
        let workoutDataManager = WorkoutDataManager()
        
        let exerciseForPreview = workoutDataManager.fetchExercises(for: workoutForPreview, in: persistenceController.container.viewContext)[0]
        
        let actionForPreview = (exerciseForPreview.toExerciseViewRepresentation()?.actions[0])!
            
        ActionTimedView(action: actionForPreview, showTitle: true)
    }
}
