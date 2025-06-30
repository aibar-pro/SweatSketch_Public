//
//  DecimalTextField.swift
//  SweatSketch
//
//  Created by aibaranchikov on 27.06.2025.
//

import SwiftUI

struct DecimalTextField: View {
    @Binding var value: Double
    @State private var text: String = ""
    
    var placeholder: String = ""
    private let decimalSeparator = Locale.current.decimalSeparator ?? "."
    
    var body: some View {
        TextField(placeholder, text: textBinding)
            .keyboardType(.decimalPad)
            .onAppear { text = formatted(value) }
            .onChange(of: value) { newValue in
                text = formatted(newValue)
            }
            .multilineTextAlignment(.trailing)
    }
    
    private var textBinding: Binding<String> {
        Binding<String>(
            get: { text },
            set: { newText in
                var filtered = newText.filter { $0.isNumber || String($0) == decimalSeparator }
                if filtered.filter({ String($0) == decimalSeparator }).count > 1 {
                    var seen = 0
                    filtered = filtered.filter {
                        if String($0) == decimalSeparator {
                            seen += 1
                            return seen <= 1
                        }
                        return true
                    }
                }
                
                text = filtered
                
                let normalized = text.replacingOccurrences(of: decimalSeparator, with: ".")
                if let parsed = Double(normalized) {
                    value = parsed
                }
            }
        )
    }
    
    private func formatted(_ value: Double) -> String {
        let str = String(value)
        if str.hasSuffix(".0") {
            return String(str.dropLast(2))
        }
        return str
    }
}
