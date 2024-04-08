//
//  WorkoutPlanListView.swift
//  MyWorkoutPlanner
//
//  Created by aibaranchikov on 12/5/21.
//

import SwiftUI
import CoreData

struct WorkoutCarouselCardView: View {
    
    @ObservedObject var viewModel: WorkoutCarouselViewModel

    @Binding var presentedWorkoutIndex: Int
    
    var body: some View {
        GeometryReader { geoReader in
            let cardSpacing: CGFloat = min(geoReader.size.width * 0.05, Constants.Design.spacing)
            let cardWidth: CGFloat = geoReader.size.width - (cardSpacing*2.5)
            let cardHeight: CGFloat = geoReader.size.height * 0.95
            
            HStack(alignment: .center, spacing: cardSpacing) {
                ForEach(viewModel.workouts, id: \.id) { workout in
                    WorkoutDetailView(workoutRepresentation: workout)
                        .padding(.all, Constants.Design.spacing/2)
                        .materialCardBackgroundModifier()
                        .frame(width: cardWidth, height: cardHeight, alignment: .top)
                }
            }
            .animation(Animation.bouncy(duration: 0.5))
            .modifier(SnapCarouselModifier(items: viewModel.workouts.count, itemWidth: cardWidth, itemSpacing: cardSpacing, screenWidth: geoReader.size.width, currentIndex: $presentedWorkoutIndex))
        }
    }
}

struct WorkoutPlanCarouselView_Previews: PreviewProvider {
    static var previews: some View {

        let persistenceController = PersistenceController.preview
        
        let collectionDataManager = CollectionDataManager()
        let firstCollection = collectionDataManager.fetchFirstUserCollection(in: persistenceController.container.viewContext)
        
        let workoutViewModel = WorkoutCarouselViewModel(context: persistenceController.container.viewContext, collectionUUID: firstCollection?.uuid)
        
        WorkoutCarouselCardView(viewModel: workoutViewModel, presentedWorkoutIndex: .constant(0))

    }
}
