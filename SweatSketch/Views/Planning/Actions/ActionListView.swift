//
//  ExerciseActionView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 20.03.2024.
//

import SwiftUI

struct ActionListView: View {
    
    @ObservedObject var exercise: ExerciseViewViewModel
    
    var body: some View {
        
        VStack (alignment: .leading) {
            switch exercise.type {
            case .setsNreps:
                    HStack (spacing: 0) {
                        ForEach(exercise.actions.indices, id: \.self) { index in
                            HStack (spacing: 0) {
                                ActionSetsNRepsView(action: exercise.actions[index])
                                    .layoutPriority(1)
                                    .truncationMode(.tail)
                                Text(index != exercise.actions.endIndex - 1 ? ", " : "")
                                    .truncationMode(.tail)
                            }
                        }
                    }
                    .truncationMode(.tail)
                    .lineLimit(1)
            case .timed:
                    HStack {
                        ForEach(exercise.actions.indices, id: \.self) { index in
                            HStack (spacing: 0){
                                ActionTimedView(action: exercise.actions[index])
                                    .truncationMode(.tail)
                                    .layoutPriority(1)
                                Text(index != exercise.actions.endIndex - 1 ? "," : "")
                                    .truncationMode(.tail)
                            }
                            .truncationMode(.tail)
                            .layoutPriority(-Double(index))
                        }
                    }
                    .truncationMode(.tail)
                    .lineLimit(1)
            case .mixed:
                VStack (alignment: .leading, spacing: Constants.Design.spacing/2) {
                    ForEach(exercise.actions.indices, id: \.self) { index in
                        switch exercise.actions[index].type {
                        case .setsNreps:
                            ActionSetsNRepsView(action: exercise.actions[index], showTitle: true, showSets: false)
                                .truncationMode(.tail)
                        case .timed:
                            ActionTimedView(action: exercise.actions[index], showTitle: true)
                                .truncationMode(.tail)
                        default:
                            Text(Constants.Placeholders.noActionDetails)
                        }
                    }
                }
                .lineLimit(1)
            case .unknown:
                Text(Constants.Placeholders.noExerciseDetails)
            }
        }
    }
}

struct ActionListView_Previews: PreviewProvider {
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        
        let collectionDataManager = CollectionDataManager()
        let firstCollection = collectionDataManager.fetchFirstUserCollection(in: persistenceController.container.viewContext)!
        let workoutForPreview = collectionDataManager.fetchWorkouts(for: firstCollection, in: persistenceController.container.viewContext).first!
        
        let workoutDataManager = WorkoutDataManager()
        
        let exerciseForPreview0 = workoutDataManager.fetchExercises(for: workoutForPreview, in: persistenceController.container.viewContext)[0]
        let exerciseForPreview1 = workoutDataManager.fetchExercises(for: workoutForPreview, in: persistenceController.container.viewContext)[1]
        let exerciseForPreview2 = workoutDataManager.fetchExercises(for: workoutForPreview, in: persistenceController.container.viewContext)[2]
        
        VStack (spacing: 100) {
            ActionListView(exercise: exerciseForPreview0.toExerciseViewRepresentation()!)
            
            ActionListView(exercise: exerciseForPreview1.toExerciseViewRepresentation()!)
            
            ActionListView(exercise: exerciseForPreview2.toExerciseViewRepresentation()!)
            
        }
    }
}

