//
//  ActiveWorkoutRestTimeView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 04.04.2024.
//

import SwiftUI

struct ActiveWorkoutRestTimeView: View {
    
    let restTime: ActiveWorkoutItemRepresentation
    var doneRequested: () -> ()
    var returnRequested: () -> ()
    
    @State private var timeRemaining = Constants.DefaultValues.restTimeDuration
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        HStack (alignment: .top, spacing: Constants.Design.spacing/2) {
            Button(action: { returnRequested() }){
                Image(systemName: "chevron.backward")
                    .secondaryButtonLabelStyleModifier()
            }
            
            VStack (alignment: .leading, spacing: Constants.Design.spacing/2) {
                Text(restTime.name)
                    .font(.headline.bold())
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
            
                DurationView(durationInSeconds: timeRemaining)
                    .onAppear(perform: {
                        timeRemaining = Int(restTime.restTimeDuration ?? Int32(Constants.DefaultValues.restTimeDuration))
                    })
                    .onReceive(timer) { time in
                        if timeRemaining > 0 {
                            timeRemaining -= 1
                        }
                    }
            }
            Spacer()
            
            Button(action: { doneRequested() }){
                Image(systemName: "chevron.forward")
                    .primaryButtonLabelStyleModifier()
            }
        }
    }
}

//#Preview {
//    ActiveWorkoutRestTimeView()
//}
