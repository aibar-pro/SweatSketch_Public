//
//  ExerciseView.swift
//  MyWorkoutPlanner
//
//  Created by aibaranchikov on 12/5/21.
//

import SwiftUI

struct ExerciseEditView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var workout: WorkoutEntity
    
    @Binding var showExerciseModal: Bool
    
    @State var exerciseName: String = ""
    
    enum exerciseTypes: String, CaseIterable, Identifiable {
        case dumbbell, barbell, stack, time, none
        var id: Self { self }
    }
    @State private var exerciseType: exerciseTypes = .dumbbell
    
    @State var newExerciseItems = [ExerciseActionEntity]()
    
    @State var isEditingList : Bool = false
    
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor (keyPath: \WeightPlate.weight, ascending: true)],
//        animation: .default)
//    private var weightPlates: FetchedResults<WeightPlate>
    
    private func saveExercise() {
        
        let newExercise = ExerciseEntity(context: viewContext)
        newExercise.name = exerciseName
        
        newExerciseItems.forEach({
            newExercise.addToExerciseActions($0)
        })
        
        workout.addToExercises(newExercise)
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func onItemDelete(offsets: IndexSet) {
        
        offsets.map { newExerciseItems[$0] }.forEach({ item in
            newExerciseItems.removeAll(where: {$0 == item})
            viewContext.delete(item)
        })
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    private func onItemMove(source: IndexSet, destination: Int) {
        newExerciseItems.move(fromOffsets: source, toOffset: destination)
    }
    
    var body: some View {
        
        let paddingValue : CGFloat = 20
        
        GeometryReader { gReader in
            VStack (alignment: .leading) {
                VStack (alignment: .leading) {
                    HStack {
                        Text("New exercise")
                            .bold()
                        Spacer()
                        Button(action: {
                            self.isEditingList.toggle()
                        }) {
                            Image(systemName: self.isEditingList ?  "checkmark.circle" : "line.horizontal.3")
                                .frame(width: 60, height: 60)
                                .padding(.horizontal, paddingValue)
                        }
                    }
                    .font(.title)
                    .frame(width: gReader.size.width, alignment: .leading)
                    
                    HStack {
                        Text("Name: ")
                        
                        TextField("New exercise", text: $exerciseName)
                    }
                }
                .padding(.horizontal, paddingValue)
                .padding(.top, paddingValue * 2)
                
                HStack (spacing: 20) {
                   Picker("Type", selection: $exerciseType) {
                            ForEach(exerciseTypes.allCases) { type in
                                Text(type.rawValue.capitalized)
                            }
                        }
                   .pickerStyle(.segmented)
                }
                .padding(.leading, 20)
                .frame(width: gReader.size.width, height: 50, alignment: .center)
                
                GeometryReader { listGeo in
                    HStack {
                        NavigationView {
                            List {
//                                let weights = weightPlates.sorted(by: { $0.weight < $1.weight})
                                
                                if newExerciseItems.count>0 {
                                    
                                    ForEach(newExerciseItems) { item in
                                        
//                                        ExerciseItemEditView(exerciseItem: item, weightPlates: weights)
                                        
                                    }
                                    .onDelete(perform: onItemDelete)
                                    .onMove(perform: onItemMove)
                                    .disabled(self.isEditingList)
                                } else {
                                    EmptyView()
                                }
                            }
                            .navigationBarHidden(true)
                            .environment(\.editMode,
                                         .constant(self.isEditingList ? EditMode.active : EditMode.inactive))
                            .animation(Animation.easeInOut(duration: 0.25))
                            .listStyle(.plain)
                            .padding(.leading, paddingValue)
                            .frame(width: listGeo.size.width * 0.85, height: listGeo.size.height, alignment: .topLeading)
                            
                        }
                        
                        if self.isEditingList == false {
                            VStack (alignment: .center) {
                                
                                Button(action: {
                                    let addedExerciseItem = ExerciseActionEntity(context: viewContext)
                                    self.newExerciseItems.append(addedExerciseItem)
                                }) {
                                    Image(systemName: "plus")
                                }
                                .padding(10)
                                .background(
                                    ZStack {
                                        Circle()
                                            .stroke(Color.blue, lineWidth: 2)
                                    }
                                )
                                .padding(.top, newExerciseItems.count > 0 ? paddingValue : 0)
                                
                                VStack {
                                    ForEach(newExerciseItems) { item in
                                        ZStack {
                                            if item.reps > 0 && item.sets > 0 {
                                                Circle()
                                                    .fill()
                                                    .foregroundColor(.blue)
                                            }
                                            Circle()
                                                .stroke(lineWidth: 1.0)
                                                .foregroundColor(.blue)
                                        }
                                        
                                    }
                                }
                                .frame(width: listGeo.size.width * 0.05, height: CGFloat(30 * newExerciseItems.count))
                            }
                            .frame(width: newExerciseItems.count > 0 ? listGeo.size.width * 0.15 : listGeo.size.width, height: listGeo.size.height, alignment: newExerciseItems.count > 0 ? .top : .top)
                        } else {
                            EmptyView()
                        }
                    }
                }
                
                Button(action: {
                      saveExercise()

                      showExerciseModal.toggle()

                  }) {
                      Text("Save")
                  }
                  .disabled(
                      exerciseName.isEmpty
                  )
                  .frame(width: gReader.size.width, alignment: .center)
                  .padding(.vertical, paddingValue * 2)
            }
        }
    }
}

import CoreData

struct ExerciseEditView_Previews: PreviewProvider {
    static var previews: some View {
        
        let context = PersistenceController.preview.container.viewContext
     
        let planFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "WorkoutEntity")
        
        let plans = try! context.fetch(planFetch) as! [WorkoutEntity]
        
//        let exercise = plans[0].exercises?.array[0] as! Exercise
        
        ExerciseEditView(workout: plans[0], showExerciseModal: .constant(true))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
