//
//  ExerciseDetailView.swift
//  MyWorkoutPlanner
//
//  Created by aibaranchikov on 24.11.2023.
//

import SwiftUI

struct ExerciseDetailView: View {
    @ObservedObject var exercise: ExerciseRepresentation
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.Design.spacing) {
            HStack(alignment: .top, spacing: Constants.Design.spacing) {
                Text(exercise.name)
                    .fullWidthText(.title3, weight: .bold)
                    .lineLimit(2)
                
                Spacer(minLength: 0)
                
                if exercise.superSets > 1 {
                    Text("x\(exercise.superSets)")
                        .font(.title3)
                }
            }
            .adaptiveForegroundStyle(Constants.Design.Colors.elementFgHighEmphasis)
            
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
        let hideIcon  = exercise.actions.allEqual { $0.type.kind }
        let hideTitle = exercise.actions.allEqual { $0.title }
        
        return VStack(alignment: .leading, spacing: Constants.Design.spacing) {
            ForEach(exercise.actions, id: \.id) { action in
                ActionDetailView(action: action, hideTitle: hideTitle, hideIcon: hideIcon)
            }
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
        
        let exerciseRepresentation = exercise.toExerciseRepresentation()!
        ExerciseDetailView(exercise: exerciseRepresentation)
    }
}
