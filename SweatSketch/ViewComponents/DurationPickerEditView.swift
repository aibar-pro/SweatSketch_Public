//
//  TimePickerView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 26.03.2024.
//

import SwiftUI

struct DurationPickerEditView: View {
   
    @Binding var durationInSeconds: Int

    private var hours: Int { Int(durationInSeconds) / 3600 }
    private var minutes: Int { (Int(durationInSeconds) % 3600) / 60 }
    private var seconds: Int { Int(durationInSeconds) % 60 }
    
    var body: some View {
        HStack (alignment: .center, spacing: Constants.Design.spacing/2) {
            Picker("Hours", selection: Binding(
                get: { self.hours },
                set: { newValue in
                    self.updateTotalSeconds(hours: newValue, minutes: self.minutes, seconds: self.seconds)
                }
            )) {
                ForEach(0..<24, id: \.self) { hour in
                    Text("\(hour)").tag(hour)
                }
            }
            .labelsHidden()
            .pickerStyle(WheelPickerStyle())
            Text(":")
            
            Picker("Minutes", selection: Binding(
               get: { self.minutes },
               set: { newValue in
                   self.updateTotalSeconds(hours: self.hours, minutes: newValue, seconds: self.seconds)
               }
           )) {
               ForEach(0..<60, id: \.self) { minute in
                   Text("\(minute)").tag(minute)
               }
           }
           .labelsHidden()
           .pickerStyle(WheelPickerStyle())
            Text(":")
            
            Picker("Seconds", selection: Binding(
                get: { self.seconds },
                set: { newValue in
                    self.updateTotalSeconds(hours: self.hours, minutes: self.minutes, seconds: newValue)
                }
            )) {
                ForEach(0..<60, id: \.self) { second in
                    Text("\(second)").tag(second)
                }
            }
            .labelsHidden()
            .pickerStyle(WheelPickerStyle())
        }
    }
    
    private func updateTotalSeconds(hours: Int, minutes: Int, seconds: Int) {
        self.durationInSeconds = (hours * 3600) + (minutes * 60) + seconds
    }
}

#Preview {
    DurationPickerEditView(durationInSeconds: .constant(4000))
}
