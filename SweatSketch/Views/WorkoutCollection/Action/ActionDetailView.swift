//
//  ActionDetailView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 25.06.2025.
//

import SwiftUI

struct ActionDetailView: View {
    @ObservedObject var action: ActionRepresentation
    
    var hideTitle: Bool = false
    var hideIcon: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.Design.spacing / 2) {
            if !action.title.isEmpty, !hideTitle {
                Text(action.title)
                    .font(.headline.weight(.light))
                    .adaptiveForegroundStyle(Constants.Design.Colors.elementFgMediumEmphasis)
                    .lineLimit(1)
            }
            
            HStack(alignment: .firstTextBaseline, spacing: Constants.Design.spacing / 2) {
                if !hideIcon {
                    Image(systemName: action.type.iconName)
                        .adaptiveForegroundStyle(Constants.Design.Colors.elementFgPrimary)
                }
                
                Text(action.type.primaryLabel)
                    .font(.title3.weight(.medium))
                    .adaptiveForegroundStyle(Constants.Design.Colors.elementFgHighEmphasis)
                
                if let suffix = action.type.setsSuffix {
                    Text(suffix)
                        .font(.footnote)
                        .adaptiveForegroundStyle(Constants.Design.Colors.elementFgMediumEmphasis)
                }
            }
        }
        .accessibilityElement(children: .combine)
    }
}

struct ActionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        
        let collectionDataManager = CollectionDataManager()
        let firstCollection = collectionDataManager
            .fetchFirstUserCollection(in: persistenceController.container.viewContext)
        let workoutForPreview = collectionDataManager
            .fetchWorkouts(for: firstCollection!, in: persistenceController.container.viewContext)
            .first!
        
        let exercise = try! WorkoutDataManager()
            .fetchExercises(for: workoutForPreview, in: persistenceController.container.viewContext)
            .get()
            .first!
        
        let action = ExerciseDataManager()
            .fetchActions(for: exercise, in: persistenceController.container.viewContext)
            .first!
            .toActionViewRepresentation()!
        
        ActionDetailView(action: action)
    }
}
