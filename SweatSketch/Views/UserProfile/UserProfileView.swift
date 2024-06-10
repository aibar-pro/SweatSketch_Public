//
//  UserProfileView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 18.06.2024.
//

import SwiftUI

struct UserProfileView: View {
    var onLogout: () -> ()
    var onDismiss: () -> ()
    
    @ObservedObject var viewModel: UserProfileViewModel
    
    var body: some View {
        VStack {
            HStack {
                Button(action: onDismiss) {
                    Image(systemName: "chevron.backward")
                    
                }
                .padding(.vertical, Constants.Design.spacing/2)
                .padding(.trailing, Constants.Design.spacing/2)
                
                Spacer()
                
                if !viewModel.isLoading {
                    Button(action: onLogout) {
                        HStack(spacing: Constants.Design.spacing/2) {
                            Text(Constants.Placeholders.UserProfile.logoutButtonLabel)
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                        }
                    }
                    .padding(.vertical, Constants.Design.spacing/2)
                    .padding(.leading, Constants.Design.spacing/2)
                }
            }
            .padding(.horizontal, Constants.Design.spacing)
            
            Spacer()
            
            if viewModel.isLoading {
                ProgressView(Constants.Placeholders.loaderText)
            } else {
                Text("Hello, \(viewModel.profileName)!")
            }
            Spacer()
        }
    }
}

#Preview {
    UserProfileView(onLogout: {}, onDismiss: {}, viewModel: UserProfileViewModel())
}
