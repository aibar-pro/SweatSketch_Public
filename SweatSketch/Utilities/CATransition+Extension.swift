//
//  CATransition+Extension.swift
//  SweatSketch
//
//  Created by aibaranchikov on 02.06.2025.
//

import UIKit

extension CATransition {
    public static func push(_ direction: CATransitionSubtype, duration: TimeInterval = 0.5) -> CATransition {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = direction
        return transition
    }
    
    public static func fade(duration: TimeInterval = 0.5) -> CATransition {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        return transition
    }
    
    public static func reveal(duration: TimeInterval = 0.5) -> CATransition {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        return transition
    }
}
