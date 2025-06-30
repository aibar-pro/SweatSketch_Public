//
//  TimeUnit.swift
//  SweatSketch
//
//  Created by aibaranchikov on 26.06.2025.
//

import SwiftUICore

enum TimeUnit {
    case second
    case minute
    case hour
    
    var localizedShortDescription: LocalizedStringKey {
        switch self {
        case .second:
            return "app.time.unit.second.short"
        case .minute:
            return "app.time.unit.minute.short"
        case .hour:
            return "app.time.unit.hour.short"
        }
    }
}
