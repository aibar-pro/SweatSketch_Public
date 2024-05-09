//
//  ExerciseView.swift
//  MyWorkoutPlanner
//
//  Created by aibaranchikov on 24.11.2023.
//

import SwiftUI

struct ExerciseView: View {
    
    @ObservedObject var exerciseRepresentation: ExerciseViewRepresentation
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack (alignment: .top){
                Image(systemName: exerciseRepresentation.type.iconName)
                    .padding(Constants.Design.spacing/4)
                    .frame(width: Constants.Design.spacing*1.5)
                
                VStack (alignment: .leading) {
                    HStack (alignment: .top) {
                        Text(exerciseRepresentation.name)
                            .font(.title2)
                            .lineLimit(2)
                        Spacer()
                        if exerciseRepresentation.type == .mixed {
                            Text("x\(exerciseRepresentation.superSets)")
                                .font(.title2)
                                .padding(.trailing, Constants.Design.spacing/4)
                        } else {
                            EmptyView()
                        }
                    }
                    .padding(.bottom, Constants.Design.spacing/4)
                    
                    ActionListView(exercise: exerciseRepresentation)
                        .customForegroundColorModifier(Constants.Design.Colors.textColorMediumEmphasis)
                }
            }
        }
    }
}

struct ExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        
        let persistenceController = PersistenceController.preview
        
        let collectionDataManager = CollectionDataManager()
        let firstCollection = collectionDataManager.fetchFirstUserCollection(in: persistenceController.container.viewContext)
        let workoutForPreview = collectionDataManager.fetchWorkouts(for: firstCollection!, in: persistenceController.container.viewContext).first!
        
        let workoutDataManager = WorkoutDataManager()
        let exercise = workoutDataManager.fetchExercises(for: workoutForPreview, in: persistenceController.container.viewContext).first!
        
        let exerciseRepresentation = exercise.toExerciseViewRepresentation()!
        ExerciseView(exerciseRepresentation: exerciseRepresentation)
    }
}
