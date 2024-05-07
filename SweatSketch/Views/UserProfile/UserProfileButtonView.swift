//
//  UserProfileButtonView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 07.05.2024.
//

import SwiftUI

struct UserProfileButtonView: View {
    var onClick: () -> ()
    
    var body: some View {
        Button (action: onClick) {
            HStack {
                Image(systemName: "person")
                Text("Login")
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: Constants.Design.cornerRadius)
                    .stroke( Constants.Design.Colors.textColorMediumEmphasis, lineWidth: 2)
            )
        }
    }
}

#Preview {
    UserProfileButtonView(onClick: {})
}
