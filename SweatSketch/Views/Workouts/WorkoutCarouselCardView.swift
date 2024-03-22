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
                ForEach(viewModel.workouts, id: \.self) { plan in
                    WorkoutDetailView(workout: plan)
                        .padding(.all, Constants.Design.spacing/2)
                        .modifier(CardBackgroundModifier(cornerRadius: Constants.Design.cornerRadius))
                        .frame(width: cardWidth, height: cardHeight, alignment: .top)
                        .animation(Animation.bouncy(duration: 0.5))
                    
                }
            }
            .modifier(SnapCarouselModifier(items: viewModel.workouts.count, itemWidth: cardWidth, itemSpacing: cardSpacing, screenWidth: geoReader.size.width, currentIndex: $presentedWorkoutIndex))
        }
    }
}

struct WorkoutPlanCarouselView_Previews: PreviewProvider {
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        
        WorkoutCarouselCardView(viewModel: WorkoutCarouselViewModel(context: persistenceController.container.viewContext), presentedWorkoutIndex: .constant(0))

    }
}
