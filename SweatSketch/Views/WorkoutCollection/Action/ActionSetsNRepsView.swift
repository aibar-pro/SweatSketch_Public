//
//  ActionSetsNRepsView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 26.03.2024.
//

import SwiftUI

struct ActionSetsNRepsView: View {
    var action: ActionRepresentation
    
    var showTitle: Bool = false
    var showSets: Bool = true
    
    var body: some View {
        if case .reps(let sets, let min, let max, let isMax) = action.type {
            HStack(alignment: .top, spacing: Constants.Design.spacing) {
                if showTitle {
                    Text("\(action.title),")
                }
                
                HStack(alignment: .center, spacing: 0) {
                    if showSets {
                        Text("\(sets)")
                    }
                    if isMax {
                        Text("x\(Constants.Placeholders.maximumRepetitionsLabel))")
                    } else if let max {
                        Text("x\(min)-\(max)")
                    } else {
                        Text("x\(min)")
                    }
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
        
        let exerciseForPreview = try! workoutDataManager.fetchExercises(for: workoutForPreview, in: persistenceController.container.viewContext).get().randomElement()!
        
        let actionForPreview = (exerciseForPreview.toExerciseRepresentation()?.actions[0])!
        
        VStack (spacing: 50) {
            ActionSetsNRepsView(action: actionForPreview, showTitle: true)
            
            ActionSetsNRepsView(action: actionForPreview, showSets: false)
        }
    }
}
