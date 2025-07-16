//
//  NetworkService.swift
//  SweatSketch
//
//  Created by aibaranchikov on 09.05.2024.
//

import Foundation
import SweatSketchSharedModule

// Calling Kotlin suspend functions from Swift/Objective-C is currently supported only on main thread
class NetworkService {
    static let shared = NetworkService()
    
    private let authRepository: AuthRepository
    private let userRepository: UserRepository

    private init() {
        _ = KoinInitializerKt.doInitKoin(baseUrl: "http://0.0.0.0:8080")
        self.authRepository = DIHelper().authRepository
        self.userRepository = DIHelper().userRepository
    }

    @MainActor
    func isLoggedIn() async -> Bool {
        await withCheckedContinuation { continuation in
            authRepository.isLoggedIn { response, error in
                if let response = response {
                    print("\(type(of: self)): \(#function): response: \(response.boolValue)")
                    continuation.resume(returning: response.boolValue)
                } else {
                    continuation.resume(returning: false)
                }
            }
        }
    }

    @MainActor
    func login(user: UserCredentialModel) async throws -> Bool {
        try await withCheckedThrowingContinuation { continuation in
            authRepository.login(userCredential: user.toShared()) { response, error in
                if response != nil {
                    UserSession.shared.checkLoginStatus()
                    continuation.resume(returning: true)
                } else if let error = error {
                    print("\(type(of: self)): \(#function): Login failed with error: \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    @MainActor
    func logout() async throws -> Bool {
        try await withCheckedThrowingContinuation { continuation in
            authRepository.logout { response, error in
                if response != nil {
                    UserSession.shared.checkLoginStatus()
                    continuation.resume(returning: true)
                } else if let error = error {
                    print("NETWORK SERVICE: Logout failed with error: \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    @MainActor
    func createUser(user: UserCredentialModel) async throws -> Bool {
        try await withCheckedThrowingContinuation { continuation in
            userRepository.createUser(userCredential: user.toShared()) { response, error in
               if response != nil {
                    continuation.resume(returning: true)
                } else if let error = error {
                    print("NETWORK SERVICE: User CREATE failed with error: \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    @MainActor
    func createDefaultUserProfile(username: String) async throws -> Bool {
        try await withCheckedThrowingContinuation { continuation in
            let defaultProfile = UserProfileModel(username: username)
                .toShared()
            
            userRepository.createUserProfile(userProfile: defaultProfile) { response, error in
                if response != nil {
                    continuation.resume(returning: true)
                }
                
                guard let error else {
                    continuation.resume(throwing: APIError.unknownError())
                    return
                }
                
                continuation.resume(throwing: APIError.map(error))
            }
        }
    }
    
    @MainActor
    func getUserProfile() async throws -> UserProfileModel {
        try await withCheckedThrowingContinuation { continuation in
            userRepository.getUserProfile() { response, error in
                if let response = response {
                    continuation.resume(returning: response.toLocal())
                }
                
                guard let error else {
                    continuation.resume(throwing: APIError.unknownError())
                    return
                }
                
                continuation.resume(throwing: APIError.map(error))
            }
        }
    }
    
    @MainActor
    func updateUser(userProfile: UserProfileModel) async throws -> Bool {
        try await withCheckedThrowingContinuation { continuation in
            userRepository.updateUserProfile(userProfile: userProfile.toShared()) { response, error in
                if response != nil {
                    continuation.resume(returning: true)
                }
                
                guard let error else {
                    continuation.resume(throwing: APIError.unknownError())
                    return
                }
                
                continuation.resume(throwing: APIError.map(error))
            }
        }
    }
}
