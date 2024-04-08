//
//  WorkoutCollectionEditView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 09.04.2024.
//

import SwiftUI

struct WorkoutCollectionEditView: View {
    @EnvironmentObject var coordinator: WorkoutCollectionEditCoordinator
    @ObservedObject var viewModel: WorkoutCollectionEditViewModel
    
    var body: some View {
        
        ZStack {
            WorkoutPlanningModalBackgroundView()
            
            VStack (alignment: .leading, spacing: Constants.Design.spacing) {
                Text(viewModel.editingCollection.name ?? "New collection")
                    .padding(.horizontal, Constants.Design.spacing)
                    .font(.title2.bold())
                
                TextField("Enter collection name: ", text: Binding(get: {  viewModel.editingCollection.name ?? Constants.Placeholders.noCollectionName }, set: {  viewModel.editingCollection.name = $0
                }))
                .padding(Constants.Design.spacing/2)
                .background(
                    RoundedRectangle(cornerRadius: Constants.Design.cornerRadius)
                        .stroke(Constants.Design.Colors.backgroundStartColor)
                )
                .padding(.horizontal, Constants.Design.spacing)
                
                HStack (alignment: .center, spacing: Constants.Design.spacing/2) {
                    Spacer()
                    
                    Button(action: {
                        coordinator.discardCollectionEdit()
                    }) {
                        Text("Cancel")
                            .secondaryButtonLabelStyleModifier()
                    }
                    
                    Button(action: {
                        coordinator.saveCollection()
                    }) {
                        Text("Done")
                            .bold()
                            .primaryButtonLabelStyleModifier()
                    }
                    
                }
                .padding(.horizontal, Constants.Design.spacing)
            }
            .accentColor(Constants.Design.Colors.textColorHighEmphasis)
        }
    }
}

struct WorkoutCollectionEditView_Previews: PreviewProvider {
    
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        
        let collectionsViewModel = WorkoutCollectionViewModel(context: persistenceController.container.viewContext)
        let collectionEditViewModel = WorkoutCollectionEditViewModel(parentViewModel: collectionsViewModel)
        
        let collectionEditCoordinator = WorkoutCollectionEditCoordinator(viewModel: collectionEditViewModel)
        
        
        WorkoutCollectionEditView(viewModel: collectionEditViewModel)
            .environmentObject(collectionEditCoordinator)
    }
}
