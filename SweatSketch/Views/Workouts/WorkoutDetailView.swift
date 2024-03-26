//
//  ExcerciseView.swift
//  MyWorkoutPlanner
//
//  Created by aibaranchikov on 7/5/21.
//

import SwiftUI

struct WorkoutDetailView: View {
    
    @ObservedObject var workout: WorkoutEntity
    
    var body: some View {
        GeometryReader { geoReader in
            ScrollView { 
                VStack (alignment: .leading, spacing: 25) {
                    let exercises =
                    workout.exercises?.array as? [ExerciseEntity] ?? []
                    
                    if exercises.count>0 {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach (exercises, id: \.self) { exercise in
                                ExerciseView(exercise: exercise)
                                    .padding(.bottom, Constants.Design.spacing)
                                    .frame(width: geoReader.size.width, alignment: .leading)
                            }
                        }
                    } else {
                        Text("No exercises")
                    }
                }
            }
            
        }
    }
}

import CoreData

struct WorkoutPlanView_Previews: PreviewProvider {
    static var previews: some View {
        
        let persistenceController = PersistenceController.preview
        let workoutCarouselViewModel = WorkoutCarouselViewModel(context: persistenceController.container.viewContext)
        
        WorkoutDetailView(workout: workoutCarouselViewModel.workouts[0])
    }
}
