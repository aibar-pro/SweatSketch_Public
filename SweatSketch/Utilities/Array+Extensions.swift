//
//  Array+Extensions.swift
//  SweatSketch
//
//  Created by aibaranchikov on 18.06.2025.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Collection {
    func allEqual<T: Equatable>(by key: (Element) -> T) -> Bool {
        guard let first = self.first.map(key) else { return true }
        return allSatisfy { key($0) == first }
    }
}
