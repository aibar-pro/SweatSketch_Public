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
                                Text(Constants.Design.Placeholders.exerciseActionName+",")
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
        let persistenceController = PersistenceController.preview
        let workoutCarouselViewModel = WorkoutCarouselViewModel(context: persistenceController.container.viewContext)
       
        let exercise = workoutCarouselViewModel.workouts[0].exercises![0] as! ExerciseEntity
        let exercise1 = workoutCarouselViewModel.workouts[0].exercises![1] as! ExerciseEntity
        let exercise2 = workoutCarouselViewModel.workouts[0].exercises![2] as! ExerciseEntity
        
        VStack (spacing: 50) {
            ExerciseActionListView(exercise: exercise)
    
            ExerciseActionListView(exercise: exercise1)

            ExerciseActionListView(exercise: exercise2)
        }
    }
}

