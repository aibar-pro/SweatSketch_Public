//
//  WorkoutDefaultRestTimeEditView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 28.03.2024.
//

import SwiftUI
    
struct DefaultRestTimePopoverView: View {
    
    @EnvironmentObject var coordinator: WorkoutEditCoordinator
    
    @ObservedObject var restTimeEntity: RestTimeEntity
    @Binding var showPopover: Bool
    @State var duration: Int
    
    init(restTimeEntity: RestTimeEntity, showPopover: Binding<Bool>) {
        self.restTimeEntity = restTimeEntity
        self._showPopover = showPopover
        self.duration = Int(restTimeEntity.duration)
    }
    
    var body: some View {
        VStack (alignment: .leading, spacing: Constants.Design.spacing) {
            HStack {
                Text ("Rest between exercises")
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
                    Button(action: {
                        showPopover.toggle()
                        coordinator.goToAdvancedEditRestPeriod()
                    }) {
                        HStack {
                            Text("Advanced edit")
                            Image(systemName: "arrow.up.right")
                        }
                        .foregroundSecondaryColorModifier()
                    }
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
                    self.restTimeEntity.duration = Int32(duration)
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

struct DefaultRestTimePopoverView_Preview : PreviewProvider {
    
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        let workoutCarouselViewModel = WorkoutCarouselViewModel(context: persistenceController.container.viewContext)
        let workoutEditViewModel = WorkoutEditTemporaryViewModel(parentViewModel: workoutCarouselViewModel, editingWorkout: workoutCarouselViewModel.workouts[0])
        let workoutEditCoordinator = WorkoutEditCoordinator(viewModel: workoutEditViewModel)
        
        let restTime = workoutEditViewModel.defaultRestTime!
        
        DefaultRestTimePopoverView(restTimeEntity: restTime, showPopover: .constant(true))
            .environmentObject(workoutEditCoordinator)
    }
}
