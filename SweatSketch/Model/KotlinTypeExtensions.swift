//
//  KotlinTypeExtensions.swift
//  SweatSketch
//
//  Created by aibaranchikov on 08.06.2024.
//

import Foundation
import SweatSketchSharedModule

extension Int32 {
    var kotlinInt: KotlinInt {
        return KotlinInt(value: self)
    }
}

extension Double {
    var kotlinDouble: KotlinDouble {
        return KotlinDouble(value: self)
    }
}

extension Optional where Wrapped == Int32 {
    var kotlinInt: KotlinInt? {
        guard let self = self else { return nil }
        return KotlinInt(value: self)
    }
}

extension Optional where Wrapped == Double {
    var kotlinDouble: KotlinDouble? {
        guard let self = self else { return nil }
        return KotlinDouble(value: self)
    }
}

extension Optional where Wrapped == KotlinInt {
    var intValue: Int32? {
        guard let self = self else { return nil }
        return self.int32Value
    }
}

extension Optional where Wrapped == KotlinDouble {
    var doubleValue: Double? {
        guard let self = self else { return nil }
        return self.doubleValue
    }
}
