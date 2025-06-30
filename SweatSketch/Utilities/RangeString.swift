//
//  RangeString.swift
//  SweatSketch
//
//  Created by aibaranchikov on 30.06.2025.
//


extension Equatable where Self: CustomStringConvertible {
    func rangeString(
        to max: Self?,
        unit: String? = nil
    ) -> String {
        let suffix = unit.map { " \($0)" } ?? ""
        if let max = max, max != self {
            return "\(self)-\(max)\(suffix)"
        } else {
            return "\(self)\(suffix)"
        }
    }
}
