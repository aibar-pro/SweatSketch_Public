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
