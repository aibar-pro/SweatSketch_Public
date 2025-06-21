//
//  WorkoutCatalogWorkoutRowView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 12.04.2024.
//

import SwiftUI

struct WorkoutCatalogWorkoutRowView: View {
    @ObservedObject var workout: WorkoutRepresentation
    @Binding var isLoggedIn: Bool
    
    var onMoveRequested: (WorkoutRepresentation) -> ()
    var onShareRequested: (WorkoutRepresentation) -> ()
    
    var body: some View {
        Menu {
            Button("catalog.workout.move") {
               onMoveRequested(workout)
            }

            Button("catalog.workout.share") {
                onShareRequested(workout)
            }
            .disabled(!isLoggedIn)
       } label: {
           Text(workout.name)
               .fullWidthText()
               .lineLimit(1)
       }
    }
}

struct WorkoutCatalogWorkoutRowView_Previews: PreviewProvider {
    
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        
        let collectionDataManager = CollectionDataManager()
        let firstCollection = collectionDataManager.fetchFirstUserCollection(in: persistenceController.container.viewContext)
        
        let workoutForPreview = (firstCollection?.toWorkoutCollectionRepresentation()?.workouts.first)!
        
        WorkoutCatalogWorkoutRowView(
            workout: workoutForPreview,
            isLoggedIn: .constant(true),
            onMoveRequested: { workout in },
            onShareRequested: { _ in }
        )
    }
}
