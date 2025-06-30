//
//  ChipsRow.swift
//  SweatSketch
//
//  Created by aibaranchikov on 30.06.2025.
//

import SwiftUI

struct QuickChip {
    let label: String
    let apply: () -> Void
}
    
extension QuickChip: Hashable, Equatable {
    static func == (lhs: QuickChip, rhs: QuickChip) -> Bool {
        lhs.label == rhs.label
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(label)
    }
}

struct ChipsRow: View {
    let chips: [QuickChip]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center, spacing: Constants.Design.spacing / 2) {
                ForEach(chips, id: \.self) { chip in
                    Text(chip.label)
                        .padding(.horizontal, Constants.Design.buttonLabelPaddding)
                        .padding(.vertical, Constants.Design.buttonLabelPaddding / 2)
                        .background(
                            Capsule()
                                .fill(Constants.Design.Colors.elementFgPrimary.opacity(0.12))
                        )
                        .onTapGesture { chip.apply() }
                }
            }
        }
    }
}

#Preview {
    ChipsRow(
        chips: AppLanguage.allCases.map { lang in
            QuickChip(
                label: lang.rawValue,
                apply: {
                    print(lang.rawValue)
                }
            )
        }
    )
}
