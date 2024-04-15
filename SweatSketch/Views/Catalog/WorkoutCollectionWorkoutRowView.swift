//
//  WorkoutCollectionWorkoutRowView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 12.04.2024.
//

import SwiftUI

struct WorkoutCollectionWorkoutRowView: View {
    @ObservedObject var workoutRepresentation: WorkoutCollectionWorkoutViewRepresentation
    
    var onMoveRequested: (_ workout: WorkoutCollectionWorkoutViewRepresentation) -> ()
    
    var body: some View {
        HStack {
            Text(workoutRepresentation.name)
                .lineLimit(2)
            
            Spacer()
            
            Menu {
                Button("Move workout") {
                    onMoveRequested(workoutRepresentation)
                }
                
                Button("One more action") {
                    
                }
                
            } label: {
                Image(systemName: "ellipsis")
                    .padding(.vertical, Constants.Design.spacing/2)
                    .padding(.leading, Constants.Design.spacing/2)
            }
        }

    }
}

struct WorkoutCollectionWorkoutRowView_Previews: PreviewProvider {
    
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        
        let collectionDataManager = CollectionDataManager()
        let firstCollection = collectionDataManager.fetchFirstUserCollection(in: persistenceController.container.viewContext)
        
        let workoutForPreview = (firstCollection?.toWorkoutCollectionRepresentation()?.workouts.first)!
        
        WorkoutCollectionWorkoutRowView(workoutRepresentation: workoutForPreview, onMoveRequested: {workout in })
    }
}
