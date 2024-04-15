//
//  ActiveWorkoutExerciseView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 04.04.2024.
//

import SwiftUI

struct ActiveWorkoutExerciseView: View {
    
    @ObservedObject var viewModel: ActiveWorkoutExerciseViewModel

    var doneRequested: () -> ()
    var returnRequested: () -> ()
    
    var body: some View {
//        GeometryReader { geoReader in
        VStack (alignment: .leading, spacing: Constants.Design.spacing/2) {
            HStack (alignment: .center, spacing: Constants.Design.spacing/2) {
                Button(action: { 
                    if viewModel.isFirstAction {
                        returnRequested()
                        print("RETURN")
                    } else {
                        viewModel.previousAction()
                    }
                }){
                    Image(systemName: "chevron.backward")
                        .secondaryButtonLabelStyleModifier()
                }
                
                Spacer()
                
                if !viewModel.actions.isEmpty, let currentAction = viewModel.currentAction {
                    
//                    VStack (alignment: .center, spacing: Constants.Design.spacing){
                        
                        switch currentAction.type {
                        case .setsNreps:
                            if let repsMax = currentAction.repsMax, repsMax {
                                Text("xMAX")
                                    .font(.title2.bold())
                            } else if let reps = currentAction.reps {
                                Text("x\(reps)")
                                    .font(.title2.bold())
                            }
                        default:
                            if let duration = currentAction.duration {
                                CountdownTimerView(timeRemaining: Int(duration))
                                    .font(.title2.bold())
                            }
                        }
                        
                        
//                    }
                } else {
                    ErrorMessageView(text: Constants.Placeholders.noActionDetails)
                }
                
                Spacer()
                
                Button(action: {
                    if viewModel.isLastAction {
                        doneRequested()
                        print("DONE")
                    } else {
                        viewModel.nextAction()
                        print("NEXT")
                    }
                }){
                    Image(systemName: "chevron.forward")
                        .primaryButtonLabelStyleModifier()
                }
            }
            
            Text(viewModel.currentAction?.title ?? Constants.Placeholders.noActionName)
                .font(.headline)
                .lineLimit(3)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, Constants.Design.spacing)
            
            if viewModel.exerciseTitle != viewModel.currentAction?.title {
                Text(viewModel.exerciseTitle)
                    .font(.subheadline)
                    .lineLimit(1)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, Constants.Design.spacing)
            }
            
            if let currentIndex = viewModel.actions.firstIndex(where: {$0 == viewModel.currentAction }) {
                ProgressBarView(totalSections: viewModel.actions.count, currentSection: currentIndex)
                    .frame(height: 25)
                    .padding(.horizontal, Constants.Design.spacing)
            }
        }
    }
}

struct ActiveWorkoutExerciseView_Previews: PreviewProvider {
    
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        
        let collectionDataManager = CollectionDataManager()
        let firstCollection = collectionDataManager.fetchFirstUserCollection(in: persistenceController.container.viewContext)
        
        let workoutForPreview = collectionDataManager.fetchWorkouts(for: firstCollection!, in: persistenceController.container.viewContext).first
        
        let exerciseForPreview = try! ActiveWorkoutViewRepresentation(workoutUUID: (workoutForPreview?.uuid)!, in: persistenceController.container.viewContext).items[2]
//        let exerciseForPreview = (workoutForPreview?.exercises![0] as! ExerciseEntity).toActiveWorkoutItemRepresentation()!
        
        let exerciseModel = ActiveWorkoutExerciseViewModel(exerciseRepresentation: exerciseForPreview)
        
        ActiveWorkoutExerciseView(viewModel: exerciseModel, doneRequested: {}, returnRequested: {})
    }
}
