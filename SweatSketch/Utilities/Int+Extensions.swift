//
//  Int+Extensions.swift
//  SweatSketch
//
//  Created by aibaranchikov on 18.06.2025.
//

import Foundation

extension Int {
    func durationString() -> String {
        let hours = self / 3600
        let minutes = (self % 3600) / 60
        let seconds = self % 60
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func formattedTime(components: Int = 2) -> String {
        let hours = self / 3600
        let minutes = (self % 3600) / 60
        let seconds = self % 60
        switch components {
        case 1:
            return String(format: "%02d", hours)
        case 2:
            return String(format: "%02d:%02d", hours, minutes)
        case 3:
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        default:
            return ""
        }
    }
    
    
}
