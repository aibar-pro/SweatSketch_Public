//
//  ExerciseView.swift
//  MyWorkoutPlanner
//
//  Created by aibaranchikov on 24.11.2023.
//

import SwiftUI

struct ExerciseView: View {
    
    @ObservedObject var exerciseEntity: ExerciseEntity
    
    var body: some View {
        VStack (alignment: .leading) {
            let exerciseType = ExerciseType.from(rawValue: exerciseEntity.type)
            
            HStack (alignment: .top){
                Image(systemName: exerciseType.iconName)
                    .padding(Constants.Design.spacing/4)
                    .frame(width: Constants.Design.spacing*1.5)
                
                VStack (alignment: .leading) {
                    HStack (alignment: .bottom) {
                        Text(exerciseEntity.name ?? Constants.Design.Placeholders.noExerciseName)
                            .font(.title2)
                            .lineLimit(2)
                        Spacer()
                        if exerciseType == .mixed {
                            Text("x\(exerciseEntity.superSets)")
                                .font(.title2)
                                .padding(.trailing, Constants.Design.spacing/4)
                        } else {
                            EmptyView()
                        }
                    }
                    .padding(.bottom, Constants.Design.spacing/4)
                    
                    ActionListView(exerciseEntity: exerciseEntity)
                        .opacity(0.8)
                }
            }
        }
    }
}

struct ExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        
        let persistenceController = PersistenceController.preview
        let workoutCarouselViewModel = WorkoutCarouselViewModel(context: persistenceController.container.viewContext)
       
        let exercise = workoutCarouselViewModel.workouts[0].exercises![0] as! ExerciseEntity
        let exercise1 = workoutCarouselViewModel.workouts[0].exercises![1] as! ExerciseEntity
        let exercise2 = workoutCarouselViewModel.workouts[0].exercises![2] as! ExerciseEntity
        
        VStack (spacing: 50) {
            ExerciseView(exerciseEntity: exercise)
            ExerciseView(exerciseEntity: exercise1)
            ExerciseView(exerciseEntity: exercise2)
        }
    }
}
