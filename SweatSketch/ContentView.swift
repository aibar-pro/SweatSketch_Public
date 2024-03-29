//
//  ContentView.swift
//  MyWorkoutPlanner
//
//  Created by aibaranchikov on 7/5/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @EnvironmentObject var coordinator: ApplicationCoordinator
    
    var body: some View {
        ZStack {
            WorkoutPlanningMainBackgroundView()
            ApplicationCoordinatorRepresentable(coordinator: coordinator)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
       
        let persistenceController = PersistenceController.preview

        ContentView()
            .environmentObject(ApplicationCoordinator(dataContext: persistenceController.container.viewContext))

    }
}
