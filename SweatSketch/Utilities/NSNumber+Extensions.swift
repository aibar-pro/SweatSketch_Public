//
//  File.swift
//  SweatSketch
//
//  Created by aibaranchikov on 20.06.2025.
//

import Foundation

extension Optional where Wrapped == NSNumber {
    var intValue: Int? {
        guard let self else { return nil }
        return self.intValue
    }
    
    var doubleValue: Double? {
        guard let self else { return nil }
        return self.doubleValue
    }
}

extension Int {
    var nsNumber: NSNumber {
        return NSNumber(value: self)
    }
}

extension Double {
    var nsNumber: NSNumber {
        return NSNumber(value: self)
    }
}

extension Int {
    var int16: Int16 {
        return Int16(self)
    }
    
    var int32: Int32 {
        return Int32(self)
    }
}

extension Int32 {
    var int: Int {
        return Int(self)
    }
}

extension Int16 {
    var int: Int {
        return Int(self)
    }
}
