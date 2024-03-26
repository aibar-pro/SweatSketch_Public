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
                    .frame(width: Constants.Design.spacing*1.5)
                
                VStack (alignment: .leading) {
                    HStack (alignment: .bottom) {
                        Text(exercise.name ?? Constants.Design.Placeholders.noExerciseName)
                            .font(.title2)
                            .lineLimit(2)
                        Spacer()
                        if exerciseType == .mixed {
                            Text("x\(exercise.superSets)")
                                .font(.title2)
                                .padding(.trailing, Constants.Design.spacing/4)
                        } else {
                            EmptyView()
                        }
                    }
                    .padding(.bottom, Constants.Design.spacing/4)
                    
                    ActionListView(exercise: exercise)
                        .opacity(0.8)
                }
            }
        }
    }
}

import CoreData

struct ExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        
        let persistenceController = PersistenceController.preview
        let workoutCarouselViewModel = WorkoutCarouselViewModel(context: persistenceController.container.viewContext)
       
        let exercise = workoutCarouselViewModel.workouts[0].exercises![0] as! ExerciseEntity
        let exercise1 = workoutCarouselViewModel.workouts[0].exercises![1] as! ExerciseEntity
        let exercise2 = workoutCarouselViewModel.workouts[0].exercises![2] as! ExerciseEntity
        
        VStack (spacing: 50) {
            ExerciseView(exercise: exercise)
            ExerciseView(exercise: exercise1)
            ExerciseView(exercise: exercise2)
        }
    }
}
