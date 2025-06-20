//
//  UserSession.swift
//  SweatSketch
//
//  Created by aibaranchikov on 11.06.2024.
//

import Foundation

class UserSession: ObservableObject {
    static let shared = UserSession()
    
    @Published private(set) var isLoggedIn: Bool = false
    
    private init() {
        checkLoginStatus()
    }
    
    func checkLoginStatus() {
        Task {
            print("USER SESSION: old status = \(self.isLoggedIn)")
            self.isLoggedIn = await NetworkService.shared.isLoggedIn()
            print("USER SESSION: new status = \(self.isLoggedIn)")
        }
    }
}
