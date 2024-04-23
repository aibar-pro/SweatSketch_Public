//
//  MyWorkoutPlannerApp.swift
//  MyWorkoutPlanner
//
//  Created by aibaranchikov on 7/5/21.
//

import SwiftUI

@main
struct SweatSketchApp: App {
    
    @StateObject var applicationCoordinator = ApplicationCoordinator(dataContext: PersistenceController.shared.container.viewContext)
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(applicationCoordinator)
        }
    }
}
/*
struct MyWorkoutPlannerApp_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
*/
