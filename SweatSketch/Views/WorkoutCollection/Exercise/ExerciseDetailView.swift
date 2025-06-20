//
//  ExerciseDetailView.swift
//  MyWorkoutPlanner
//
//  Created by aibaranchikov on 24.11.2023.
//

import SwiftUI

struct ExerciseDetailView: View {
    @ObservedObject var exercise: ExerciseViewRepresentation
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.Design.spacing / 2) {
            HStack(alignment: .top, spacing: Constants.Design.spacing) {
                Text(exercise.name)
                    .fullWidthText(.title3, isBold: true)
                    .lineLimit(2)
                
                Spacer(minLength: 0)
                
                if exercise.superSets > 1 {
                    Text("x\(exercise.superSets)")
                        .font(.title3)
                }
            }
            .customForegroundColorModifier(Constants.Design.Colors.textColorHighEmphasis)
            
            Group {
                if exercise.actions.count > 0 {
                    actions
                } else {
                    Text("exercise.detail.no.actions")
                        .fullWidthText()
                }
            }
            .padding(.leading, Constants.Design.spacing)
        }
    }
        
    private var actions: some View {
        VStack(alignment: .leading, spacing: Constants.Design.spacing / 2) {
//            ForEach(exercise.actions, id: \.id) { action in
//                Text(action.type.description, " - \(action.name)")
//                    .fullWidthText()
//            }
        }
    }
}

struct ExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        
        let persistenceController = PersistenceController.preview
        
        let collectionDataManager = CollectionDataManager()
        let firstCollection = collectionDataManager.fetchFirstUserCollection(in: persistenceController.container.viewContext)
        let workoutForPreview = collectionDataManager.fetchWorkouts(for: firstCollection!, in: persistenceController.container.viewContext).first!
        
        let workoutDataManager = WorkoutDataManager()
        
        let exercise = try! workoutDataManager.fetchExercises(for: workoutForPreview, in: persistenceController.container.viewContext).get().first!
        
        let exerciseRepresentation = exercise.toExerciseViewRepresentation()!
        ExerciseDetailView(exercise: exerciseRepresentation)
    }
}
