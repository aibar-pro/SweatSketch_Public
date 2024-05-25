//
//  DurationView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 26.03.2024.
//

import SwiftUI

struct DurationView: View {
    var durationInSeconds: Int

    private var hours: Int {
        durationInSeconds / 3600
    }
    
    private var minutes: Int {
        durationInSeconds / 60 % 60
    }
    
    private var seconds: Int {
        durationInSeconds % 60
    }
    
    private var durationString: String {
        var result: String = ""
        if hours > 0 {
            result.append("\(hours):")
            
            if minutes > 9 { result.append("\(minutes):") }
            else { result.append("0\(minutes):") }
            
            if seconds > 9 { result.append("\(seconds)") }
            else { result.append("0\(seconds)") }
        } else if minutes > 0 {
            result.append("\(minutes):")
            
            if seconds > 9 { result.append("\(seconds)") }
            else { result.append("0\(seconds)") }
        } else {
            result.append("\(seconds) \(Constants.Placeholders.secondsLabel)")
        }
        
                                            
        return result
    }
    
    var body: some View {
        Text(durationString)
    }
}

#Preview {
    DurationView(durationInSeconds: 10)
}
