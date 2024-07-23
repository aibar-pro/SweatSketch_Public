//
//  ErrorManager.swift
//  SweatSketch
//
//  Created by aibaranchikov on 23.07.2024.
//

import Foundation
import Combine

class ErrorManager: ObservableObject {
    static let shared = ErrorManager()
    @Published var showError = false
    @Published var errorMessage = ""
    
    private var cancellable: AnyCancellable?

    func displayError(message: String, duration: TimeInterval = 3.0) {
        Task { @MainActor in
            self.errorMessage = message
            self.showError = true
            
            self.cancellable?.cancel()
            
            self.cancellable = Just(())
                .delay(for: .seconds(duration), scheduler: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.hideError()
                }
        }
    }
    
    func hideError() {
        self.showError = false
        self.errorMessage = ""
    }
    
}
