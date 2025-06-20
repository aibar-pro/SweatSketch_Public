//
//  WorkoutDetailView.swift
//  MyWorkoutPlanner
//
//  Created by aibaranchikov on 7/5/21.
//

import SwiftUI

struct WorkoutDetailView: View {
    @ObservedObject var workout: WorkoutViewRepresentation
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            Group {
                if !workout.exercises.isEmpty {
                    VStack(alignment: .leading, spacing: Constants.Design.spacing * 1.5) {
                        ForEach(workout.exercises, id: \.id) { exercise in
                            ExerciseDetailView(exercise: exercise)
                        }
                    }
                } else {
                    Text("workout.detail.no.exercises")
                        .fullWidthText()
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct WorkoutPlanView_Previews: PreviewProvider {
    static var previews: some View {
        
        let persistenceController = PersistenceController.preview
        
        let collectionDataManager = CollectionDataManager()
        let firstCollection = collectionDataManager.fetchFirstUserCollection(in: persistenceController.container.viewContext)
        
        let workoutForPreview = collectionDataManager.fetchWorkouts(for: firstCollection!, in: persistenceController.container.viewContext).first
        
        if let workoutRepresentation = workoutForPreview?.toWorkoutViewRepresentation() {
            WorkoutDetailView(workout: workoutRepresentation)
        }
    }
}
