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
        VStack (alignment: .leading, spacing: Constants.Design.spacing/2) {
            HStack(alignment: .top) {
                VStack (alignment: .leading, spacing: Constants.Design.spacing/2) {
                    Text(viewModel.currentAction?.title ?? Constants.Placeholders.noActionName)
                        .font(.headline.bold())
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                    if viewModel.exerciseTitle != viewModel.currentAction?.title {
                        Text(viewModel.exerciseTitle)
                            .font(.subheadline)
                            .lineLimit(1)
                            .multilineTextAlignment(.leading)
                    }
                }
                Spacer()
                if !viewModel.actions.isEmpty, let currentAction = viewModel.currentAction {
                    switch currentAction.type {
                    case .setsNreps:
                        if let repsMax = currentAction.repsMax, repsMax {
                            Text("xMAX")
                                .font(.headline.bold())
                        } else if let reps = currentAction.reps {
                            Text("x\(reps)")
                                .font(.headline.bold())
                        }
                    default:
                        if currentAction.duration != nil {
                            CountdownTimerView(timeRemaining: $viewModel.currentActionTimeRemaining)
                                .font(.headline.bold())
                        }
                    }
                } else {
                    ErrorMessageView(text: Constants.Placeholders.noActionDetails)
                }
            }
            
            if let currentIndex = viewModel.actions.firstIndex(where: {$0 == viewModel.currentAction }) {
                ProgressBarView(totalSections: viewModel.actions.count, currentSection: currentIndex)
                    .frame(height: 25)
            }
            HStack (alignment: .center, spacing: Constants.Design.spacing/2) {
                Button(action: {
                    if viewModel.isFirstAction {
                        returnRequested()
                    } else {
                        viewModel.previousAction()
                    }
                }){
                    Image(systemName: "chevron.backward")
                        .secondaryButtonLabelStyleModifier()
                }
                
                Spacer()
                
                Button(action: {
                    if viewModel.isLastAction {
                        doneRequested()
                    } else {
                        viewModel.nextAction()
                    }
                }){
                    Image(systemName: "chevron.forward")
                        .padding(.horizontal, Constants.Design.spacing)
                        .primaryButtonLabelStyleModifier()
                }
            }
        }
    }
}

struct ActiveWorkoutExerciseView_Previews: PreviewProvider {
    
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        
        let appCoordinator = ApplicationCoordinator(dataContext: persistenceController.container.viewContext)
        let workoutEvent = appCoordinator.workoutEvent
        
        let collectionDataManager = CollectionDataManager()
        let firstCollection = collectionDataManager.fetchFirstUserCollection(in: persistenceController.container.viewContext)
        
        let workoutForPreview = collectionDataManager.fetchWorkouts(for: firstCollection!, in: persistenceController.container.viewContext).first
        
        let workoutUUID = (workoutForPreview?.uuid)!
        
        let activeWorkoutCoordinator = try! ActiveWorkoutCoordinator(dataContext: persistenceController.container.viewContext, activeWorkoutUUID: workoutUUID, workoutEvent: workoutEvent)
        
        let exerciseForPreview = try! ActiveWorkoutViewRepresentation(workoutUUID: (workoutForPreview?.uuid)!, in: persistenceController.container.viewContext).items[4]
        
        let exerciseModel = ActiveWorkoutExerciseViewModel(parentViewModel: activeWorkoutCoordinator.viewModel, exerciseRepresentation: exerciseForPreview)
        
        ActiveWorkoutExerciseView(viewModel: exerciseModel, doneRequested: {}, returnRequested: {})
    }
}
