//
//  ColorExtension.swift
//  BeerMenu
//
//  Created by aibaranchikov on 8/4/21.
//

import SwiftUI

extension Color {
    static let offWhite = Color(red: 225 / 255, green: 225 / 255, blue: 235 / 255)
    
    static let neuBackground = Color(hex: "f0f0f3")
    
    static let dropShadow = Color(hex: "aeaec0") // Color(hex: "aeaec0").opacity(0.4)
    static let dropLight = Color(hex: "ffffff")
    
    static let haloStroke = Color(hex: "fff3b2") // fff3b2
    static let haloShadow = Color(hex: "ffdf32") // ffdf32
    
    static let innerShadowStroke = Color(hex: "eceaeb") // Color(red: 236/255, green: 234/255, blue: 235/255)
    static let innerShadowShadow = Color(hex: "c0bdbf") // Color(red: 192/255, green: 189/255, blue: 191/255)
}

extension Color {
    init(hex: String) {
        
        let lowerCasedHex = hex.lowercased()
        let filteredHex = lowerCasedHex.filter("1234567890abcdef".contains)
        
        let trimmedIndex = filteredHex.index(filteredHex.startIndex, offsetBy: 6)
        let trimmedHex = filteredHex[filteredHex.startIndex..<trimmedIndex]
        
        let rIndex = trimmedHex.startIndex
        let gIndex = trimmedHex.index(trimmedHex.startIndex, offsetBy: 2)
        let bIndex = trimmedHex.index(trimmedHex.startIndex, offsetBy: 4)

        let r = Int(hex[rIndex..<gIndex], radix: 16) ?? 0
        let g = Int(hex[gIndex..<bIndex],radix:16) ?? 0
        let b = Int(hex[bIndex..<hex.endIndex],radix: 16) ?? 0
        
        self.init(red: Double(r) / 0xff, green: Double(g) / 0xff, blue: Double(b) / 0xff)
    }
}
