//
//  StringLocalizedExtension.swift
//  SweatSketch
//
//  Created by aibaranchikov on 09.06.2024.
//

import Foundation

extension String {
    static func localized(_ key: String) -> String {
        if #available(iOS 16.0, *) {
            return String(localized: LocalizedStringResource(stringLiteral: key))
        } else {
            return key
        }
    }
}
