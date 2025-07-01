//
//  Binding+Extensions.swift
//  
//
//  Created by aibaranchikov on 30.06.2025.
//

import SwiftUICore

extension Binding where Value == String {
    func asInt(minimum: Int = Int.min) -> Binding<Int> {
        Binding<Int>(
            get: { Int(wrappedValue) ?? minimum },
            set: { wrappedValue = String($0) }
        )
    }
}

extension Binding where Value == Double {
    func asInt() -> Binding<Int> {
        Binding<Int>(
            get: { Int(wrappedValue.rounded()) },
            set: { wrappedValue = Double($0) }
        )
    }
}

extension Binding where Value == Double? {
    func or(_ defaultValue: Double) -> Binding<Double> {
        Binding<Double>(
            get: { wrappedValue ?? defaultValue },
            set: { value in wrappedValue = value }
        )
    }
}
