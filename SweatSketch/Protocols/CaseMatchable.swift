//
//  CaseMatchable.swift
//  SweatSketch
//
//  Created by aibaranchikov on 25.06.2025.
//


protocol CaseMatchable {
    func matchesCase(_ other: Self) -> Bool
}

extension CaseMatchable {
    func isOne(of states: Self...) -> Bool {
        states.contains(where: matchesCase(_:))
    }
}
