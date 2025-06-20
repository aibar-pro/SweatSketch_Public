//
//  IntegerTextField.swift
//  SweatSketch
//
//  Created by aibaranchikov on 18.06.2025.
//

import SwiftUI

struct IntegerTextField<N>: View where N: BinaryInteger & LosslessStringConvertible {
    @Binding var value: N
    @State private var text: String = ""

    var placeholder: String = ""

    var body: some View {
        TextField(placeholder, text: textBinding)
            .keyboardType(.numberPad)
            .onAppear { text = String(value) }
    }

    private var textBinding: Binding<String> {
        Binding<String>(
            get: { text },
            set: { newValue in
                let filtered = newValue.filter { $0.isNumber }
                let cleaned = filtered.drop { $0 == "0" && filtered.count > 1 }
                text = String(cleaned)

                if let parsed = N(text) {
                    value = parsed
                }
            }
        )
    }
}
