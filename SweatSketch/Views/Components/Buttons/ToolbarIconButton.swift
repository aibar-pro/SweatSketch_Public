//
//  ToolbarIconButton.swift
//  SweatSketch
//
//  Created by aibaranchikov on 16.06.2025.
//

import SwiftUI

enum ToolbarIconButton {
    case backButton(action: () -> Void)
    case closeButton(action: () -> Void)
    case doneButton(action: () -> Void)
    
    func buttonView(style: CustomButtonStyle = .inline) -> some View {
        switch self {
        case .backButton(let action):
            IconButton(
                systemImage: "chevron.left",
                style: style,
                action: action
            )
        case .closeButton(let action):
            IconButton(
                systemImage: "xmark",
                style: style,
                action: action
            )
        case .doneButton(let action):
            IconButton(
                systemImage: "checkmark",
                style: style,
                action: action
            )
        }
    }
}

#Preview {
    VStack(spacing: 50) {
        ToolbarIconButton.backButton(action: {})
            .buttonView()
            .border(Color.blue)
        
        ToolbarIconButton.closeButton(action: {})
            .buttonView(style: .accent)
            .border(Color.blue)
    }
}
