//
//  GlobalErrorView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 23.07.2024.
//

import SwiftUI

struct GlobalErrorView: View {
    @EnvironmentObject var errorManager: ErrorManager
    
    var body: some View {
        VStack {
            if errorManager.showError {
                ErrorMessageView(text: errorManager.errorMessage)
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut)
                    .padding(.horizontal, Constants.Design.spacing)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clear)
//        .edgesIgnoringSafeArea(.all)
        .onTapGesture {
            errorManager.hideError()
        }
    }
}

#Preview {
    GlobalErrorView()
        .environmentObject(ErrorManager.shared)
}
