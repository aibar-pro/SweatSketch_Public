//
//  Binding+Extensions.swift
//  
//
//  Created by aibaranchikov on 30.06.2025.
//



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
