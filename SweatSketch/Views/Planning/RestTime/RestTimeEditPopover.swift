//
//  RestTimeEditPopover.swift
//  SweatSketch
//
//  Created by aibaranchikov on 30.03.2024.
//

import SwiftUI

struct RestTimeEditPopover: View {
    @ObservedObject var restTimeEntity: RestTimeEntity
    @Binding var showPopover: Bool
    @State var duration: Int
    
    var onDuractionChange: (_ duration: Int) -> Void = { duration in }
    
    init(restTimeEntity: RestTimeEntity, showPopover: Binding<Bool>) {
        self.restTimeEntity = restTimeEntity
        self._showPopover = showPopover
        self.duration = Int(restTimeEntity.duration)
    }
    
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
                    showPopover.toggle()
                }) {
                    Text("Cancel")
                        .secondaryButtonLabelStyleModifier()
                }
                Button(action: {
//                    self.restTimeEntity.duration = Int32(duration)
                    onDuractionChange(duration)
                    showPopover.toggle()
                }) {
                    Text("Done")
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
        let workoutCarouselViewModel = WorkoutCarouselViewModel(context: persistenceController.container.viewContext)
        let workoutEditViewModel = WorkoutEditTemporaryViewModel(parentViewModel: workoutCarouselViewModel, editingWorkout: workoutCarouselViewModel.workouts[0])
        
        let restTime = workoutEditViewModel.defaultRestTime!
        
        RestTimeEditPopover(restTimeEntity: restTime, showPopover: .constant(true))
    }
}
