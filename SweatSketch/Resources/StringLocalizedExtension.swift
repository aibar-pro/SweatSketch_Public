//
//  StringLocalizedExtension.swift
//  SweatSketch
//
//  Created by aibaranchikov on 09.06.2024.
//

import SwiftUICore

extension String {
    static func localized(_ key: String) -> String {
        if #available(iOS 16.0, *) {
            return String(localized: LocalizedStringResource(stringLiteral: key))
        } else {
            return key
        }
    }
}

extension LocalizedStringKey {
    var stringKey: String? {
        Mirror(reflecting: self).children.first(where: { $0.label == "key" })?.value as? String
    }
}

extension String {
    static func localizedString(
        for key: String,
        locale: Locale = .current
    ) -> String {
        let language = locale.languageCode
        let path = Bundle.main.path(forResource: language, ofType: "lproj")!
        let bundle = Bundle(path: path)!
        let localizedString = NSLocalizedString(key, bundle: bundle, comment: "")
        
        return localizedString
    }
}

extension LocalizedStringKey {
    func stringValue(locale: Locale = .current) -> String {
        return .localizedString(for: self.stringKey ?? "", locale: locale)
    }
}
