//
//  WorkoutCollectionListView.swift
//  MyWorkoutPlanner
//
//  Created by aibaranchikov on 18/5/21.
//

import SwiftUI

struct WorkoutCollectionListView: View {
    
    @ObservedObject var viewModel: CollectionEditorModel
    
    @State private var editMode = EditMode.active
    var onSubmit: () -> Void
    var onDiscard: () -> Void
    
    var body: some View {
        content
            .onDisappear(perform: onDiscard)
    }
    
    private var content: some View {
        ZStack {
            WorkoutPlanningMainBackgroundView()
            
            VStack (alignment: .leading, spacing: Constants.Design.spacing) {
                toolbarView
                
                workoutListView
                
                buttonStackView
            }
            .padding(Constants.Design.spacing)
        }
    }
    
    private var buttonStackView: some View {
        HStack(alignment: .center, spacing: Constants.Design.spacing) {
            IconButton(
                systemImage:  "arrow.uturn.backward",
                style: .secondary,
                isDisabled: Binding { !viewModel.canUndo } set: { _ in },
                action: viewModel.undo
            )
            
            IconButton(
                systemImage:  "arrow.uturn.forward",
                style: .secondary,
                isDisabled: Binding { !viewModel.canRedo } set: { _ in },
                action: viewModel.redo
            )
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    private var workoutListView: some View {
        List {
            ForEach(viewModel.workouts, id: \.id) { plan in
                Text(plan.name)
                    .font(.title3)
                    .lineLimit(3)
                    .padding(.vertical, Constants.Design.spacing / 2)
                    .listRowBackground(Color.clear)
            }
            .onMove(perform: viewModel.moveWorkouts)
            .onDelete(perform: viewModel.deleteWorkouts)
        }
        .listStyle(.plain)
        .listRowInsets(EdgeInsets())
        .adaptiveScrollIndicatorsHidden()
        .materialBackground()
        .lightShadow()
        .environment(\.editMode, $editMode)
    }
    
    private var toolbarView: some View {
        HStack(alignment: .center, spacing: Constants.Design.spacing) {
            ToolbarIconButton
                .closeButton {
                    onDiscard()
                }
                .buttonView(style: .inline)

            Spacer(minLength: 0)
            
            Text(viewModel.collection.name ?? Constants.DefaultValues.defaultWorkoutCollectionName)
                .font(.body.bold())
                .lineLimit(2)
                .multilineTextAlignment(.center)
            
            Spacer(minLength: 0)
            
            ToolbarIconButton
                .doneButton {
                    onDiscard()
                }
                .buttonView(style: .primary)
        }
    }
}

struct WorkoutCollectionListView_Previews: PreviewProvider {
    static var previews: some View {
        
        let persistenceController = PersistenceController.preview
        let workoutViewModel = WorkoutCollectionViewModel(context: persistenceController.container.viewContext)
        let workoutListModel = CollectionEditorModel(parent: workoutViewModel, workoutCollection: workoutViewModel.workoutCollection)
        
        WorkoutCollectionListView(viewModel: workoutListModel, onSubmit: {}, onDiscard: {})
    }
}
