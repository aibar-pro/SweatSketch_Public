//
//  ApplicationEventType.swift
//  SweatSketch
//
//  Created by aibaranchikov on 02.04.2024.
//

import Foundation

enum ApplicationEventType {
    case workoutStarted(UUID)
//    case workoutFinished
    case catalogRequested
    case collectionRequested(UUID?)
    case profileRequested
}
