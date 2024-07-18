//
//  UserProfileViewModel.swift
//  SweatSketch
//
//  Created by aibaranchikov on 18.07.2024.
//

import Foundation

class UserProfileViewModel: ObservableObject {
    @Published var profileName: String = "Default profile name"
    @Published var isLoading: Bool = true
    
    init() {
        Task {
            await fetchUserProfile()
        }
    }
    
    private func fetchUserProfile() async {
        do {
            let userProfile = try await NetworkService.shared.getUserProfile()
            DispatchQueue.main.async {
                self.profileName = userProfile.login
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                print("User profile fetch failed: \(error.localizedDescription)")
                self.isLoading = false
            }
        }
    }
}
