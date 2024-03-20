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
                LazyVStack (alignment: .leading, spacing: 25) {
                    let exercises =
                    workout.exercises?.array as? [ExerciseEntity] ?? []
                    
                    if exercises.count>0 {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach (exercises) { exercise in
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
        
        let context = persistenceController.container.viewContext
     
        let planFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "WorkoutEntity")
        
        let plans = try! context.fetch(planFetch) as! [WorkoutEntity]
        
        WorkoutDetailView(workout: plans[0])

    }
}
