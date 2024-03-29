//
//  ExerciseRestTimePopoverView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 29.03.2024.
//

import SwiftUI

struct ExerciseRestTimePopoverView: View {
    
    @ObservedObject var restActionEntity: ExerciseActionEntity
    @Binding var showPopover: Bool
    @State var duration: Int
    
    init(restActionEntity: ExerciseActionEntity, showPopover: Binding<Bool>) {
        self.restActionEntity = restActionEntity
        self._showPopover = showPopover
        self.duration = Int(restActionEntity.duration)
    }
    
    var body: some View {
        VStack (alignment: .leading, spacing: Constants.Design.spacing) {
            HStack {
                Text ("Rest between actions")
                    .font(.title3.bold())
                Spacer()
                Button(action: {
                    showPopover.toggle()
                }) {
                    Image(systemName: "xmark")
                }
            }
            HStack {
                Spacer()
                VStack (alignment: .center, spacing: Constants.Design.spacing/2) {
                    DurationPickerEditView(durationInSeconds: $duration, showHours: false, secondsInterval: 10)
                        .background(
                            RoundedRectangle(cornerRadius: Constants.Design.cornerRadius)
                                .stroke(Constants.Design.Colors.backgroundStartColor)
                        )
                    .frame(width: 250, height: 150)
                }
                Spacer()
            }
            HStack (spacing: Constants.Design.spacing) {
                Spacer()
                Button(action: {
                    showPopover.toggle()
                }) {
                    Text("Cancel")
                        .secondaryButtonLabelStyleModifier()
                }
                Button(action: {
                    self.restActionEntity.duration = Int32(duration)
                    showPopover.toggle()
                }) {
                    Text("Done")
                        .bold()
                        .primaryButtonLabelStyleModifier()
                }
            }
        }
        .accentColor(Constants.Design.Colors.textColorHighEmphasis)
    }
}

struct ExerciseRestTimePopoverView_Preview: PreviewProvider {
    
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        let workoutCarouselViewModel = WorkoutCarouselViewModel(context: persistenceController.container.viewContext)
        let workoutEditViewModel = WorkoutEditTemporaryViewModel(parentViewModel: workoutCarouselViewModel, editingWorkout: workoutCarouselViewModel.workouts[0])
        let exerciseEditViewModel = ExerciseEditTemporaryViewModel(parentViewModel: workoutEditViewModel, editingExercise: workoutEditViewModel.exercises[2])
        
        let action = exerciseEditViewModel.exerciseActions[0]
        
        ExerciseRestTimePopoverView(restActionEntity: action, showPopover: .constant(true))
    }
}
