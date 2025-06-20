//
//  Double+Extensions.swift
//  SweatSketch
//
//  Created by aibaranchikov on 20.06.2025.
//

import Foundation

extension Double {
    func formatted(precision: Int = 2) -> String {
        let formatString = "%.\(precision)f"
        let fullString = String(format: formatString, self)
        
        var result = fullString
        
        while result.last == "0" {
            result.removeLast()
        }
        
        if result.last == "." {
            result.removeLast()
        }
        
        return result
    }
}
