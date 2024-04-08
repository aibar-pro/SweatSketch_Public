//
//  ExerciseRestTimePopoverView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 29.03.2024.
//

import SwiftUI

struct ExerciseRestTimePopoverView: View {
    
    var onSave: (_ : Int) -> Void
    var onDiscard: () -> Void
    
    @State var duration: Int = Constants.DefaultValues.restTimeDuration
    
    var body: some View {
        VStack (alignment: .leading, spacing: Constants.Design.spacing) {
            HStack {
                Text ("Rest between actions")
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
                    Text("Cancel")
                        .secondaryButtonLabelStyleModifier()
                }
                Button(action: {
                    onSave(duration)
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
        ExerciseRestTimePopoverView(onSave: {_ in}, onDiscard: {})
    }
}
