//
//  ActiveWorkoutExerciseView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 04.04.2024.
//

import SwiftUI

struct ActiveWorkoutExerciseView: View {
    
    let exercise: ExerciseEntity
    @State var actionCount: Int

    var doneRequested: () -> ()
    var returnRequested: () -> ()
    
    init(exercise: ExerciseEntity, doneRequested: @escaping () -> Void, returnRequested: @escaping () -> Void) {
        self.exercise = exercise
        self.actionCount = exercise.exerciseActions?.count ?? 0
        self.doneRequested = doneRequested
        self.returnRequested = returnRequested
    }
    
    var body: some View {
        
        HStack (alignment: .top, spacing: Constants.Design.spacing/2) {
            Button(action: { returnRequested() }){
                Image(systemName: "chevron.backward")
                    .secondaryButtonLabelStyleModifier()
            }
            
            VStack (alignment: .leading, spacing: Constants.Design.spacing/2) {
                if ExerciseType.from(rawValue: exercise.type) != .mixed {
                    Text(exercise.name ?? Constants.Design.Placeholders.noActionName)
                        .font(.subheadline)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                }
                
                if let actions = exercise.exerciseActions?.array as? [ExerciseActionEntity] {
                    let currentAction = actions[actions.count - actionCount]
                    
                    switch ExerciseType.from(rawValue: exercise.type) {
                    case .setsNreps:
                        Text(currentAction.repsMax ? "xMAX" : "x\(currentAction.reps)")
                            .font(.headline.bold())
                    case .timed:
                        DurationView(durationInSeconds: Int(currentAction.duration))
                            .font(.headline.bold())
                    case .mixed:
                        VStack (alignment: .leading, spacing: Constants.Design.spacing/2)  {
                            Text(currentAction.name ?? Constants.Design.Placeholders.noActionName)
                                .font(.subheadline)
                                .lineLimit(3)
                                .multilineTextAlignment(.leading)
                            
                            switch ExerciseActionType.from(rawValue: currentAction.type) {
                            case .setsNreps:
                                Text(currentAction.repsMax ? "xMAX" : "x\(currentAction.reps)")
                                    .font(.headline.bold())
                            case .timed:
                                DurationView(durationInSeconds: Int(currentAction.duration))
                                    .font(.headline.bold())
                            default:
                                Text(Constants.Design.Placeholders.noActionDetails)
                            }
                        }
                    default:
                        Text(Constants.Design.Placeholders.noActionDetails)
                    }
                    
                    HStack {
                        ForEach(actions, id: \.self) { action in
                            Circle()
                                .background(actions.firstIndex(of: action) ?? 0  <= actions.count - actionCount ?
                                            Constants.Design.Colors.buttonPrimaryBackgroundColor : Constants.Design.Colors.buttonSecondaryBackgroundColor
                                )
                                .clipShape(Circle())
                                .frame(width: 25, height: 25)
                        }
                    }
                }
            }
            Spacer()
            
            Button(action: {
                if actionCount-1 <= 0 {
                    doneRequested()
                } else {
                    actionCount -= 1
                }
            }){
                Image(systemName: "chevron.forward")
                    .primaryButtonLabelStyleModifier()
            }
        }
        
//                                                    case .rest, .timed:
//                                                        if let duration = item.duration {
//                                                            DurationView(durationInSeconds: Int(duration))
//                                                        }
//                                                    case .reps:
//                                                        if let reps = item.reps {
//                                                            Text("x\(reps)")
//                                                        } else if let repsmax = item.repsMax {
//                                                            Text ("MAX")
//                                                        }
//                                                    default:
//                                                        EmptyView()
//                                                    }
//
//                                                }
    }
}

//#Preview {
//    ActiveWorkoutExerciseView(doneRequested: {})
//}
