//
//  Text+Extensions.swift
//  SweatSketch
//
//  Created by aibaranchikov on 18.06.2025.
//

import SwiftUICore

extension Text {
    func formattedWeightUnit(_ unit: WeightUnit) -> Text {
        self + Text(" ") + Text(unit.localizedShortDescription)
    }
    
//    func formattedHeightUnit(_ unit: HeightUnit) -> Text {
//        self + Text(" ") + Text(unit.localizedShortDescription)
//    }
}

extension Text {
    func fullWidthText(
        _ style: Font = .body,
        weight: Font.Weight = .regular,
        alignment: Alignment = .leading) -> some View {
        self
            .font(style.weight(weight))
            .multilineTextAlignment(getTextAlignment(alignment))
            .frame(maxWidth: .infinity, alignment: alignment)
            .fixedSize(horizontal: false, vertical: true)
    }
    
    private func getTextAlignment(_ alignment: Alignment) -> TextAlignment {
        switch alignment {
        case .center:
            return .center
        case .trailing:
            return .trailing
        default:
            return .leading
        }
    }
}
