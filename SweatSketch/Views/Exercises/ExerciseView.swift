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
        VStack (alignment: .leading) {
            let exerciseType = ExerciseType.from(rawValue: exercise.type)
            
            HStack (alignment: .top){
                Image(systemName: exerciseType.iconName)
                    .padding(Constants.Design.spacing/4)
                
                VStack (alignment: .leading) {
                    Text(exercise.name ?? "Unnamed")
                        .font(.title2)
                        .lineLimit(2)
                    
                    if let exerciseItems = exercise.exerciseActions?.array as? [ExerciseActionEntity] {
                        if exerciseType == .mixed {
                            VStack (alignment: .leading){
                                ForEach (exerciseItems) { item in
                                    let itemType = ExerciseActionType.from(rawValue: item.type)
                                    
                                    HStack {
//                                        Image(systemName: itemType.iconName)
                                        
                                        if exercise.superSets > 0, let itemName = item.name {
                                            Text(itemName+",")
                                                .lineLimit(2)
                                        }
                                        
                                        switch itemType {
                                        case .setsNreps:
                                            Text("\(item.sets)x\(item.repsMax ? "MAX" : String(item.reps))")
                                        case .timed:
                                            Text("\(item.duration) seconds")
                                        case .unknown:
                                            EmptyView()
                                        }
                                    }
                                }
                                
                                if exercise.superSets > 0 {
                                    Text("superset, \(exercise.superSets) times")
                                        .opacity(0.7)
                                } else {
                                    EmptyView()
                                }
                            }
                        } else {
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach (exerciseItems) { item in
                                        let itemType = ExerciseActionType.from(rawValue: item.type)
                                        
                                        HStack {
                                            
                                            switch itemType {
                                            case .setsNreps:
                                                Text("\(item.sets)x\(item.repsMax ? "MAX" : String(item.reps))")
                                            case .timed:
                                                Text("\(item.duration) seconds")
                                            case .unknown:
                                                EmptyView()
                                            }
                                        }
                                    }
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
}

import CoreData

struct ExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        
        let planFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "WorkoutEntity")
        
        let plans = try! context.fetch(planFetch) as! [WorkoutEntity]
        
        let exercise = plans[0].exercises?.array[0] as! ExerciseEntity
        
        ExerciseView(exercise: exercise)
    }
}
