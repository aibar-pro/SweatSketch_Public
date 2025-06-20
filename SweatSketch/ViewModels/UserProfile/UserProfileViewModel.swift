//
//  UserProfileViewModel.swift
//  SweatSketch
//
//  Created by aibaranchikov on 18.07.2024.
//

import Foundation

class UserProfileViewModel: ObservableObject {
    @Published var isLoading: Bool = true
    
    @Published var userProfile: UserProfileModel?
    
    init() {
        fetchUserProfile()
    }
    
    private func fetchUserProfile() {
        Task { @MainActor in
            do {
                self.userProfile = try await NetworkService.shared.getUserProfile()
                self.isLoading = false
            } catch {
                print("User profile fetch failed: \(error.localizedDescription)")
                self.isLoading = false
            }
        }
    }
    
    func getGreeting() -> String {
        userProfile?.username ?? userProfile?.login ?? Constants.DefaultValues.UserProfile.username
    }
    
    func getUsername() -> String {
        userProfile?.username ?? Constants.DefaultValues.UserProfile.username
    }
    
    func getAge() -> Int {
        Int(userProfile?.age ?? Int32(Constants.DefaultValues.UserProfile.age))
    }
    
    func getHeight() -> Int {
        Int(userProfile?.height ?? Constants.DefaultValues.UserProfile.height)
    }
    
    func getWeight() -> Int {
        Int(userProfile?.weight ?? Constants.DefaultValues.UserProfile.weight)
    }
    
    func updateUsername(with username: String) {
        userProfile?.username = username
    }
    
    func updateAge(with age: Int) {
        userProfile?.age = Int32(age)
        objectWillChange.send()
    }
    
    func updateHeight(with height: Int) {
        userProfile?.height = Double(height)
        objectWillChange.send()
    }
    
    func updateWeight(with weight: Int) {
        userProfile?.weight = Double(weight)
        objectWillChange.send()
    }
}
