//
//  WorkoutCollectionListView.swift
//  MyWorkoutPlanner
//
//  Created by aibaranchikov on 18/5/21.
//

import SwiftUI

struct WorkoutCollectionListView: View {
    
    @ObservedObject var viewModel: WorkoutCollectionListViewModel
    
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
            ForEach(viewModel.workouts, id: \.self) { plan in
                Text(plan.name ?? Constants.Placeholders.noWorkoutName)
                    .font(.title3)
                    .lineLimit(3)
                    .padding(.vertical, Constants.Design.spacing / 2)
                    .listRowBackground(Color.clear)
            }
            .onMove(perform: viewModel.moveWorkout)
            .onDelete(perform: viewModel.deleteWorkout)
        }
        .listStyle(.plain)
        .environment(\.editMode, $editMode)
        .materialCardBackgroundModifier()
    }
    
    private var toolbarView: some View {
        HStack(alignment: .center, spacing: Constants.Design.spacing) {
            ToolbarIconButton
                .closeButton {
                    onDiscard()
                }
                .buttonView(style: .inline)

            Spacer(minLength: 0)
            
            Text(viewModel.workoutCollection.name ?? Constants.DefaultValues.defaultWorkoutCollectionName)
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
        let workoutListModel = WorkoutCollectionListViewModel(parentViewModel: workoutViewModel, workoutCollection: workoutViewModel.workoutCollection)
        
        WorkoutCollectionListView(viewModel: workoutListModel, onSubmit: {}, onDiscard: {})
    }
}
