//
//  ExerciseActionView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 20.03.2024.
//

import SwiftUI

struct ExerciseActionListView: View {
    
    @ObservedObject var exercise: ExerciseEntity
    
    var body: some View {
        let exerciseType = ExerciseType.from(rawValue: exercise.type)
        
        if let actions = exercise.exerciseActions?.array as? [ExerciseActionEntity] {
            VStack (alignment: .leading) {
                switch exerciseType {
                case .setsNreps:
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(actions) { action in
                                Text("\(action.sets)x\(action.repsMax ? "MAX" : String(action.reps))\(action != actions.last ? "," : "")")
                            }
                        }
                    }
                case .timed:
                    Text("\(actions.first?.duration ?? 0) seconds")
                case .mixed:
                    ForEach(actions) { action in
                        HStack (alignment: .top){
                            if let actionName = action.name {
                                Text(actionName+",")
                            } else {
                                EmptyView()
                            }
                            
                            let actionType = ExerciseActionType.from(rawValue: action.type)
                            
                            switch actionType {
                            case .setsNreps:
                                Text("\(action.sets)x\(action.repsMax ? "MAX" : String(action.reps))")
                                    .padding(.bottom, action != actions.last ?  Constants.Design.spacing/4 : 0)
                            case .timed:
                                Text("\(action.duration) seconds")
                                    .padding(.bottom, action != actions.last ?  Constants.Design.spacing/4 : 0)
                            case .unknown:
                                EmptyView()
                            }
                        }
                    }
                case .unknown: EmptyView()
                }
            }
        }
    }
}

import CoreData

struct ExerciseActionView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        
        let planFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "WorkoutEntity")
        
        let plans = try! context.fetch(planFetch) as! [WorkoutEntity]
        
        let exercise1 = plans[0].exercises?.array[0] as! ExerciseEntity
        let exercise2 = plans[0].exercises?.array[1] as! ExerciseEntity
        let exercise3 = plans[0].exercises?.array[2] as! ExerciseEntity
        
        VStack {
            ExerciseActionListView(exercise: exercise1)
    
            ExerciseActionListView(exercise: exercise2)

            ExerciseActionListView(exercise: exercise3)
        }
    }
}

