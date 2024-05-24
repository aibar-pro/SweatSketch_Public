//
//  WorkoutRestTimeView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 29.03.2024.
//

import SwiftUI

struct WorkoutRestTimeView: View {
    
    var onSave: (_ : Int) -> Void
    var onDiscard: () -> Void
    
    @State var duration: Int = Constants.DefaultValues.restTimeDuration
    
    var body: some View {
        VStack (alignment: .leading, spacing: Constants.Design.spacing) {
            HStack {
                Text (Constants.Placeholders.WorkoutCollection.exerciseRestTimeLabel)
                    .font(.title3.bold())
                Spacer()
                Button(action: {
                    onDiscard()
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
                    onDiscard()
                }) {
                    Text(Constants.Placeholders.cancelButtonLabel)
                        .secondaryButtonLabelStyleModifier()
                }
                Button(action: {
                    onSave(duration)
                }) {
                    Text(Constants.Placeholders.saveButtonLabel)
                        .bold()
                        .primaryButtonLabelStyleModifier()
                }
            }
        }
        .accentColor(Constants.Design.Colors.textColorHighEmphasis)
    }
}

struct WorkoutCustomRestTimeView_Preview: PreviewProvider {
    
    static var previews: some View {
        WorkoutRestTimeView(onSave: {_ in}, onDiscard: {})
    }
}
