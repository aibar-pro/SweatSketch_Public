//
//  ActionSetsNRepsView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 26.03.2024.
//

import SwiftUI

struct ActionSetsNRepsView: View {
    
    var action: ExerciseActionViewViewModel
    
    var showTitle: Bool = false
    var showSets: Bool = true
    
    var body: some View {
        HStack (alignment: .top) {
            if showTitle {
                Text("\(action.name),")
            }
            
            HStack (alignment: .center, spacing: 0) {
                if showSets {
                    Text("\(action.sets)")
                }
                if action.repsMax {
                    Text("xMAX")
                } else {
                    Text("x\(action.reps)")
                }
            }
        }
    }
}

struct ActionSetsNRepsView_Previews: PreviewProvider {

    static var previews: some View {
        let persistenceController = PersistenceController.preview
        
        let collectionDataManager = CollectionDataManager()
        let firstCollection = collectionDataManager.fetchFirstUserCollection(in: persistenceController.container.viewContext)!
        let workoutForPreview = collectionDataManager.fetchWorkouts(for: firstCollection, in: persistenceController.container.viewContext).first!
        
        let workoutDataManager = WorkoutDataManager()
        
        let exerciseForPreview = workoutDataManager.fetchExercises(for: workoutForPreview, in: persistenceController.container.viewContext)[1]
        
        let actionForPreview = (exerciseForPreview.toExerciseViewRepresentation()?.actions[0])!
        
        VStack (spacing: 50) {
            ActionSetsNRepsView(action: actionForPreview, showTitle: true)
            
            ActionSetsNRepsView(action: actionForPreview, showSets: false)
        }
    }
}
