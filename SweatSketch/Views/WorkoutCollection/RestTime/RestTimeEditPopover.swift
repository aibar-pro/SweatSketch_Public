//
//  RestTimeEditPopover.swift
//  SweatSketch
//
//  Created by aibaranchikov on 30.03.2024.
//

import SwiftUI

struct RestTimeEditPopover: View {
    @State var duration: Int
    
    var onDurationChange: (_ duration: Int) -> Void
    var onDiscard: () -> Void

    var body: some View {
        VStack (alignment: .leading, spacing: Constants.Design.spacing) {
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
                    onDiscard()
                }) {
                    Text(Constants.Placeholders.cancelButtonLabel)
                        .secondaryButtonLabelStyleModifier()
                }
                Button(action: {
                    onDurationChange(duration)
                }) {
                    Text(Constants.Placeholders.saveButtonLabel)
                        .bold()
                        .primaryButtonLabelStyleModifier()
                }
                Spacer()
            }
        }
        .accentColor(Constants.Design.Colors.textColorHighEmphasis)
    }
}

struct RestTimeEditPopover_Preview : PreviewProvider {
    
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        let workoutCarouselViewModel = WorkoutCollectionViewModel(context: persistenceController.container.viewContext)
        let workoutEditViewModel = WorkoutEditViewModel(parentViewModel: workoutCarouselViewModel, editingWorkoutUUID: workoutCarouselViewModel.workouts[0].id)
        
        let restTime = workoutEditViewModel.defaultRestTime
        
        RestTimeEditPopover(duration: Int(restTime.duration), onDurationChange: { duration in print("Save \(duration)") }, onDiscard: { print("Discard") })
    }
}
