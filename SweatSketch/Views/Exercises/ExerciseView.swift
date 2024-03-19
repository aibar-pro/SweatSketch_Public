//
//  ExerciseView.swift
//  MyWorkoutPlanner
//
//  Created by aibaranchikov on 24.11.2023.
//

import SwiftUI

struct ExerciseView: View {
    
    @ObservedObject var exercise: ExerciseEntity
    
    var body: some View {
        VStack (alignment: .leading, spacing: 10){
            Text(exercise.name ?? "n/a")
                .font(.title2)
            HStack (spacing: 10){
                Image(systemName: "dumbbell.fill")
                let exerciseItems = exercise.exerciseActions?.array as? [ExerciseActionEntity] ?? []
                if exerciseItems.count>0 {
                    ScrollView (.horizontal) {
                        HStack {
                            ForEach (exerciseItems) { item in
                                Text("\(item.setCount) x \(item.repCount)")
                                    .frame(width: 50, alignment: .leading)
                            }
                        }
                    }
                } else {
                    EmptyView()
                }
            }
        }
    }
}

import CoreData

struct ExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        
        let planFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "WorkoutPlan")
        
        let plans = try! context.fetch(planFetch) as! [WorkoutEntity]
        
        let exercise = plans[0].exercises?.array[0] as! ExerciseEntity
        
        ExerciseView(exercise: exercise)
    }
}
