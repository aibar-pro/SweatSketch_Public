//
//  ActionTimedView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 26.03.2024.
//

import SwiftUI

struct ActionTimedView: View {
    
    var action: ActionRepresentation
    
    var showTitle: Bool = false
    
    var body: some View {
        HStack (alignment: .top) {
            if showTitle {
                Text("\(action.title),")
            }
            //TODO: Fix
            DurationView(durationInSeconds: 99999)
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
        
        let exerciseForPreview = try! workoutDataManager.fetchExercises(for: workoutForPreview, in: persistenceController.container.viewContext).get().randomElement()!
        
        let actionForPreview = exerciseForPreview.toExerciseRepresentation()!.actions.randomElement()!
            
        ActionTimedView(action: actionForPreview, showTitle: true)
    }
}
