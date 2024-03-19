//
//  WorkoutCarouselView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 06.03.2024.
//

import SwiftUI

struct WorkoutCarouselMainView: View {
        
    @EnvironmentObject var coordinator: WorkoutCarouselCoordinator
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        GeometryReader { geoReader in
            let viewModel = coordinator.viewModel
            
            ZStack {
                BackgroundGradientView()
                
                if !viewModel.workouts.isEmpty {
                    ZStack {
                        VStack (alignment: .leading, spacing: Constants.Design.spacing) {
                            HStack {
                                Text(coordinator.getViewTitle())
                                    .font(.title2.bold())
                                    .lineLimit(2)
                                Spacer()
                                HStack {
                                    Button(action: coordinator.goToAddWorkout, label: {
                                        Image(systemName: "plus")
                                    })
                                    
                                    Menu {
                                        Button("Edit workout") {
                                            coordinator.goToEditWorkout()
                                        }
                                        
                                        Button("Reorder or delete workouts") {
                                            coordinator.goToWorkoutLst()
                                        }
                                    } label: {
                                        Image(systemName: "ellipsis.circle")
                                    }
                                }
                            }
                            .padding(.horizontal, Constants.Design.spacing)
                            .frame(height: min(geoReader.size.height*0.1, 55))
                            
                            WorkoutCarouselCardView(viewModel: viewModel, presentedWorkoutIndex: $coordinator.presentedWorkoutIndex)
                        }
                        
                        Button (action: {
                            print("Active workout index: \(coordinator.presentedWorkoutIndex) Workout count: \(coordinator.viewModel.workouts.count)")
                        }) {
                            Text("Go")
                                .accentButtonLabelStyleModifier()
                        }
                        .padding(.top, -50)
                        .frame(width: geoReader.size.width, height: geoReader.size.height, alignment: .bottom)
                    }
                    .frame(height: geoReader.size.height, alignment: .topLeading)
                } else {
                    VStack {
                        Text("No workouts")
                            .font(.title.bold())
                        Button(action: {
                            coordinator.goToAddWorkout()
                        }, label: {
                            Text("Add workout")
                                .accentButtonLabelStyleModifier()
                        })
                    }
                }
            }
        }
    }
    
    func setSheetBackgroundColor() {
        if let window = UIApplication.shared.windows.first {
            // For some reason, it picks only light scheme color >.<
            window.backgroundColor = UIColor(colorScheme == .light ?
                                             Constants.Design.Colors.backgroundStartColor : .primary)
        }
    }
}


struct WorkoutCarouselView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        
        WorkoutCarouselMainView()
            .environmentObject(WorkoutCarouselCoordinator(dataContext: persistenceController.container.viewContext))
//        
    }
}
