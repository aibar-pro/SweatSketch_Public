//
//  ItemProgress.swift
//  
//
//  Created by aibaranchikov on 09.07.2025.
//


struct ItemProgress: Equatable, Hashable, Codable {
    var stepIndex: Int = 0
    var totalSteps: Int = 0
    var stepProgress: StepProgress = .init()
}

struct StepProgress: Equatable, Hashable, Codable {
    var quantity: String = ""
    var progress: Double = 0
}

extension ItemProgress {
    mutating func update(quantity: String, progress: Double) {
        stepProgress.quantity = quantity
        stepProgress.progress = progress
    }

    mutating func reset(stepIndex: Int, totalSteps: Int, quantity: String) {
        self.stepIndex = stepIndex
        self.totalSteps = totalSteps
        self.stepProgress = StepProgress(quantity: quantity, progress: 0)
    }
}
