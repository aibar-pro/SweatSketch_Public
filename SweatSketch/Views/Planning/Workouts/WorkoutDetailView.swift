//
//  ExcerciseView.swift
//  MyWorkoutPlanner
//
//  Created by aibaranchikov on 7/5/21.
//

import SwiftUI

struct WorkoutDetailView: View {
    
    @ObservedObject var workoutRepresentation: WorkoutViewRepresentation
    
    var body: some View {
        GeometryReader { geoReader in
            ScrollView { 
                VStack (alignment: .leading, spacing: 25) {
                    if !workoutRepresentation.exercises.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach (workoutRepresentation.exercises, id: \.id) { exercise in
                                ExerciseView(exerciseRepresentation: exercise)
                                    .padding(.bottom, Constants.Design.spacing)
                                    .frame(width: geoReader.size.width, alignment: .leading)
                            }
                        }
                    } else {
                        Text("No exercises")
                    }
                }
            }
            .onReceive(workoutRepresentation.objectWillChange, perform: { _ in
                print("WORKOUT DETAIL VIEW WILL CHANGE. EXERCISES COUNT \(workoutRepresentation.exercises.count)")
            })
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
            WorkoutDetailView(workoutRepresentation: workoutRepresentation)
        }
    }
}
