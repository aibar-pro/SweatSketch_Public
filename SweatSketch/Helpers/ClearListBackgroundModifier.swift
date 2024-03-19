//
//  ClearListBackground.swift
//  MyWorkoutPlanner
//
//  Created by aibaranchikov on 24.11.2023.
//

import Foundation
import SwiftUI

struct ClearListBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content
                .scrollContentBackground(.hidden)
        } else {
            content
                .background(Color.clear)
                .onAppear {
                    UITableView.appearance().backgroundColor = .yellow
                }
                .onDisappear {
                    UITableView.appearance().backgroundColor = nil
                }
        }
    }
}
