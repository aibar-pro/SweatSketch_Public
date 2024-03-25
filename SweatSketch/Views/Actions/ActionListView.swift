//
//  ExerciseActionView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 20.03.2024.
//

import SwiftUI

struct ActionListView: View {
    
    @ObservedObject var exercise: ExerciseEntity
    
    var body: some View {
        let exerciseType = ExerciseType.from(rawValue: exercise.type)
        
        if let actions = exercise.exerciseActions?.array as? [ExerciseActionEntity] {
            VStack (alignment: .leading) {
                switch exerciseType {
                case .setsNreps:
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(actions, id: \.self) { action in
                                HStack (spacing: 0){
                                    ActionSetsNRepsView(exerciseAction: action)
                                    Text(action != actions.last ? "," : "")
                                }
                            }
                        }
                    }
                case .timed:
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(actions, id: \.self) { action in
                                HStack (spacing: 0){
                                    ActionTimedView(exerciseAction: action)
                                    Text(action != actions.last ? "," : "")
                                }
                            }
                        }
                    }
                case .mixed:
                    ForEach(actions, id: \.self) { action in
  
                        let actionType = ExerciseActionType.from(rawValue: action.type)
                        
                        switch actionType {
                        case .setsNreps:
                            ActionSetsNRepsView(exerciseAction: action,showTitle: true)
                                .padding(.bottom, action != actions.last ?  Constants.Design.spacing/4 : 0)
                        case .timed:
                            ActionTimedView(exerciseAction: action, showTitle: true)
                                .padding(.bottom, action != actions.last ?  Constants.Design.spacing/4 : 0)
                        default:
                            Text(Constants.Design.Placeholders.noActionDetails)
                        }
                    }
                case .unknown: 
                    Text(Constants.Design.Placeholders.noExerciseDetails)
                }
            }
        }
    }
}

struct ActionListView_Previews: PreviewProvider {
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        let workoutCarouselViewModel = WorkoutCarouselViewModel(context: persistenceController.container.viewContext)
       
        let exercise = workoutCarouselViewModel.workouts[0].exercises![0] as! ExerciseEntity
        let exercise1 = workoutCarouselViewModel.workouts[0].exercises![1] as! ExerciseEntity
        let exercise2 = workoutCarouselViewModel.workouts[0].exercises![2] as! ExerciseEntity
        
        VStack (spacing: 50) {
            ActionListView(exercise: exercise)
    
            ActionListView(exercise: exercise1)

            ActionListView(exercise: exercise2)
        }
    }
}

