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
                        Text(exercise.name ?? "Unnamed")
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
                    
                    ExerciseActionListView(exercise: exercise)
                        .opacity(0.8)
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
        
        let exercise = plans[0].exercises?.array[2] as! ExerciseEntity
        
        ExerciseView(exercise: exercise)
    }
}
