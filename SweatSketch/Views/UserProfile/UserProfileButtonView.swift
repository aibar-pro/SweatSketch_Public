//
//  UserProfileButtonView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 07.05.2024.
//

import SwiftUI

struct UserProfileButtonView: View {
    @Binding var isLoggedIn: Bool
    
    var onClick: () -> ()
    
    var body: some View {
        Button (action: onClick) {
            HStack (alignment: .firstTextBaseline, spacing: Constants.Design.spacing/4) {
                Image(systemName: isLoggedIn ? "person" : "person.badge.key"
                )
                Text(
                    isLoggedIn
                    ? Constants.Placeholders.UserProfile.profileButtonLabel
                    : "user.profile.login.button.label"
                )
            }
            .padding(Constants.Design.spacing/2)
            .background(
                RoundedRectangle(cornerRadius: Constants.Design.cornerRadius)
                    .stroke(Constants.Design.Colors.textColorMediumEmphasis, lineWidth: 2)
            )
        }
    }
}

#Preview {
    VStack(spacing: 50) {
        UserProfileButtonView(isLoggedIn: .constant(true), onClick: {})
        UserProfileButtonView(isLoggedIn: .constant(false), onClick: {})
    }
}
