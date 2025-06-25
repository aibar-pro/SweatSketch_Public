//
//  UserProfileButtonView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 07.05.2024.
//

import SwiftUI

struct UserProfileButtonView: View {
    @Binding var isLoggedIn: Bool
    
    var onTap: () -> Void
    
    var body: some View {
        CapsuleButton(
            content: {
                HStack(alignment: .bottom, spacing: Constants.Design.spacing/4) {
                    Image(systemName: isLoggedIn ? "person" : "person.badge.key")
                    Text(
                        isLoggedIn
                        ? "user.profile.profile.button.label"
                        : "user.profile.login.button.label"
                    )
                }
            },
            style: .secondary,
            action: {
                onTap()
            }
        )
    }
}

#Preview {
    VStack(spacing: 50) {
        UserProfileButtonView(isLoggedIn: .constant(true), onTap: {})
        UserProfileButtonView(isLoggedIn: .constant(false), onTap: {})
    }
}
