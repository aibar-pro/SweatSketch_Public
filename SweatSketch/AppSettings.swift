//
//  AppSettings.swift
//  SweatSketch
//
//  Created by aibaranchikov on 30.06.2025.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class AppSettings: ObservableObject {
    
    @AppStorage("theme") private var themeRaw = AppAppearance.system.rawValue
    @AppStorage("language") private var languageRaw = AppLanguage.device.rawValue
    @AppStorage("lengthSystem") private var lengthRaw = LengthSystem.metric.rawValue
    @AppStorage("weightSystem") private var weightRaw = WeightSystem.kilograms.rawValue
    
    @Published var appearance: AppAppearance
    @Published var language: AppLanguage
    @Published var lengthSystem: LengthSystem
    @Published var weightSystem: WeightSystem
    
    static let shared = AppSettings()
    
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
//        appearance = AppAppearance(rawValue: themeRaw) ?? .system
//        language = AppLanguage(rawValue: languageRaw) ?? .device
//        lengthSystem = LengthSystem(rawValue: lengthRaw) ?? .metric
//        weightSystem = WeightSystem(rawValue: weightRaw) ?? .kilograms
        appearance = AppAppearance.system
        language = AppLanguage.device
        lengthSystem = LengthSystem.metric
        weightSystem = WeightSystem.kilograms
        
       setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        $appearance
            .map(\.rawValue)
            .assign(to: \.themeRaw, on: self)
            .store(in: &cancellables)
        
        $language
            .map(\.rawValue)
            .assign(to: \.languageRaw, on: self)
            .store(in: &cancellables)
        
        $lengthSystem
            .map(\.rawValue)
            .assign(to: \.lengthRaw, on: self)
            .store(in: &cancellables)
        
        $weightSystem
            .map(\.rawValue)
            .assign(to: \.weightRaw, on: self)
            .store(in: &cancellables)
    }
}

enum AppAppearance: String, CaseIterable, Identifiable, Codable {
    case system, light, dark
    var id: Self { self }
    
    var localizedName: LocalizedStringKey {
        switch self {
        case .system: "settings.appearance.system"
        case .light: "settings.appearance.light"
        case .dark: "settings.appearance.dark"
        }
    }
}

enum AppLanguage: String, CaseIterable, Identifiable, Codable {
    case device = "device"
    case english = "en"
    case german = "de"
    case russian = "ru"

    var id: Self { self }

    var localeIdentifier: String? {
        self == .device ? nil : rawValue
    }
    var localizedName: LocalizedStringKey {
        switch self {
        case .device:  "settings.language.device"
        case .english: "settings.language.english"
        case .german: "settings.language.deutsch"
        case .russian: "settings.language.russian"
        }
    }
}

enum LengthSystem: String, CaseIterable, Identifiable, Codable {
    case metric, imperial
    var id: Self { self }
    
    var localizedName: LocalizedStringKey {
        switch self {
        case .metric: "settings.length.metric"
        case .imperial: "settings.length.imperial"
        }
    }
    
    var allowedUnits: [LengthUnit] {
        switch self {
        case .metric: return LengthUnit.allCases.filter(\.isMetric)
        case .imperial: return LengthUnit.allCases.filter(\.isImperial)
        }
    }
    
    var defaultUnit: LengthUnit {
        switch self {
        case .metric: return .meters
        case .imperial: return .feet
        }
    }
}

enum WeightSystem: String, CaseIterable, Identifiable, Codable {
    case kilograms, pounds
    var id: Self { self }

    var localizedName: LocalizedStringKey {
        switch self {
        case .kilograms: "settings.weight.kg"
        case .pounds: "settings.weight.lb"
        }
    }
}
