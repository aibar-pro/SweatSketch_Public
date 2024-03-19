//
//  ExerciseItemView.swift
//  MyWorkoutPlanner
//
//  Created by aibaranchikov on 7/5/21.
//

import SwiftUI

struct ExerciseActionEditView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject var exerciseAction: ExerciseActionEntity
 
//    @Binding var exerciseType: ExerciseTypes
    
    @State private var setsCount: Int = 1
    @State private var repsCount: Int = 1
    
    @State private var timeHour: Int = 0
    @State private var timeMinute: Int = 0
    @State private var timeSecond: Int = 0
    
    @State private var showWeightPlates : Bool = false
    
//    private func weightsString() -> String {
//        
//        var weightsString = ""
//        
//        let plates = self.exerciseItem.exerciseItemPlates?.array as? [ExerciseItemPlate] ?? []
//        
//        let sortedPlates = plates.sorted(by: { $0.weightPlate?.weight ?? 0 < $1.weightPlate?.weight ?? 0})
//        
//        if plates.count == 0 {
//            weightsString.removeAll()
//            weightsString.append("no")
//        } else {
//            sortedPlates.forEach( { plate in
//                let plateWeight = plate.weightPlate?.weight ?? 0
//                weightsString.append("\(plateWeight)")
//                
//                if plate != sortedPlates.last {
//                    weightsString.append("-")
//                }
//            })
//        }
//        
//        return weightsString
//    }
    
    var body: some View {
        
        GeometryReader { gReader in
            VStack (alignment: .leading, spacing: 5) {
                
                if true {
                    HStack {
                        Picker("", selection: $timeHour) {
                            ForEach(0...23, id: \.self) {
                                  Text("\($0)")
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: gReader.size.width * 0.2)
                        Text(":")
                        Picker("", selection: $timeMinute) {
                            ForEach(0...59, id: \.self) {
                                  Text("\($0)")
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: gReader.size.width * 0.2)
                        Text(":")
                        Picker("", selection: $timeSecond) {
                            ForEach(0...59, id: \.self) {
                                  Text("\($0)")
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: gReader.size.width * 0.2)
                    }
                    .padding(.leading, 20)
                .frame(width: gReader.size.width-20, height: 50, alignment: .center)
                } else {
                    /*@START_MENU_TOKEN@*/EmptyView()/*@END_MENU_TOKEN@*/
                }
                
                if true {
                    HStack (spacing: 20) {
                            Text("Sets")

                            Picker(selection: self.$setsCount, label:
                                Text("\(self.setsCount)")
                            ){
                                ForEach(1...99, id: \.self) {
                                      Text("\($0)")
                                  }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(width: gReader.size.width * 0.2)
                            .onChange(of: self.setsCount, perform: { value in
                                exerciseAction.sets = Int16(value)
                            })

                        Divider()
                            .fixedSize()
                        
                        Text("Reps")
                            .font(.title3)
                        
                        Picker(selection: self.$repsCount, label:
                            Text("\(self.repsCount)")
                        ){
                            ForEach(1...99, id: \.self) {
                                  Text("\($0)")
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: gReader.size.width * 0.2)
                        .onChange(of: self.repsCount, perform: { value in
                            exerciseAction.reps = Int16(value)
                        })
                    }
                    .frame(width: gReader.size.width, height: 50, alignment: .center)
                } else {
                    /*@START_MENU_TOKEN@*/EmptyView()/*@END_MENU_TOKEN@*/
                }
            }
            .frame(width: gReader.size.width)
        }
        .frame(height: self.showWeightPlates ? CGFloat(300) : CGFloat(105), alignment: .center)
    }
}

import CoreData

//struct ExerciseActionEditView_Previews: PreviewProvider {
//    
//    
//    static var previews: some View {
//      
////        let context = PersistenceController.preview.container.viewContext
////     
////        let exerciseItemFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ExerciseActionEntity")
////        
////        let items = try! context.fetch(exerciseItemFetch) as! [ExerciseActionEntity]
////        
////        let exerciseItem = items.sorted(by: { $0.step > $1.step})[1]
////        
////        let weightPlatesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "WeightPlate")
////        
////        let weightPlatesResult = try! context.fetch(weightPlatesFetch) as! [WeightPlate]
////
////        let weightPlates = weightPlatesResult.sorted(by: { $0.weight < $1.weight})
////        let weightPlates = [WeightPlate]()
//        
//        
////        ExerciseItemEditView(exerciseItem: exerciseItem, weightPlates: weightPlates)
////            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}

