////
////  ActionEditView.swift
////  SweatSketch
////
////  Created by aibaranchikov on 05.06.2025.
////
//
//import SwiftUI
//
//struct RepsActionEditView: View {
//    @ObservedObject var viewModel: RepsActionEditViewModel
//    
//    @State private var isActionNameFieldEnabled: Bool = false
//    @State private var isRepMaxFieldEnabled: Bool = false
//    
//    let numberWidth: CGFloat = 50
//    
//    @State private var showEditModal: Bool = false
//    
//    var body: some View {
//        VStack {
//            CapsuleButton(
//                "app.button.add.label",
//                style: .primary,
//                action: {
//                    showEditModal.toggle()
//                }
//            )
//            
//            Text("aaaa")
//            
//            Button("tap") {
//                showEditModal.toggle()
//            }
//            .sheet(isPresented: $showEditModal) {
//                repsActionModalView
//                    .roundedCornerBackground(.black)
//            }
//        }
//    }
//    
//    private var repsActionModalView: some View {
//        VStack(alignment: .leading, spacing: Constants.Design.spacing) {
//            HStack(alignment: .top, spacing: Constants.Design.spacing) {
//                IconButton(systemImage: "xmark", style: .secondary, action: {})
//                Spacer(minLength: 0)
//                IconButton(systemImage: "checkmark", style: .primary, action: {})
//            }
//  
//            actionNameView
//            
//            HStack(alignment: .center, spacing: Constants.Design.spacing) {
//                repsRangeView
//                    .disabled(!isMaximumRepetionsSelected)
//                    .opacity(isMaximumRepetionsSelected ? 1 : 0.2)
//                
//                Spacer(minLength: 0)
//                
//                HStack(alignment: .center, spacing: Constants.Design.spacing) {
//                    Text("action.edit.reps.max.label")
//                    Toggle("", isOn: viewModel.isMaxRepBinding)
//                        .labelsHidden()
//                        .customAccentColorModifier(Constants.Design.Colors.backgroundStartColor)
//                }
//            }
//            
////            buttonStackView
//        }
//    }
//    
//    private var repsRangeView: some View {
//        HStack(alignment: .center, spacing: Constants.Design.spacing) {
//            IntegerTextField(value: viewModel.repsMinBinding)
//                .padding(Constants.Design.spacing)
//                .background(
//                    RoundedRectangle(cornerRadius: Constants.Design.cornerRadius, style: .continuous)
//                        .stroke(Constants.Design.Colors.backgroundStartColor, lineWidth: 2)
//                )
//                .frame(width: numberWidth * 1.5)
//                .multilineTextAlignment(.trailing)
//           
//            Text("–")
//                .foregroundColor(.accent)
//                .opacity(isRepMaxShown || !isMaximumRepetionsSelected ? 1 : 0.2)
//            
//            Group {
//                if isRepMaxShown {
//                    IntegerTextField(value: viewModel.repsMaxBinding)
//                } else {
//                    Text(String(viewModel.action.repsMin))
//                }
//            }
//            .multilineTextAlignment(.trailing)
//            .padding(Constants.Design.spacing)
//            .frame(width: numberWidth * 1.5, alignment: .trailing)
//            .background(
//                RoundedRectangle(cornerRadius: Constants.Design.cornerRadius, style: .continuous)
//                    .stroke(Constants.Design.Colors.backgroundStartColor, lineWidth: 2)
//            )
//            .disabled(!isRepMaxShown)
//            .opacity(isRepMaxShown || !isMaximumRepetionsSelected ? 1 : 0.2)
//            .onTapGesture {
//                if !isRepMaxShown {
//                    isRepMaxFieldEnabled = true
//                }
//            }
//        }
//        .customAccentColorModifier(Constants.Design.Colors.backgroundStartColor)
//    }
//    
//    private var actionNameView: some View {
//        Group {
//            if isActionNameFieldEnabled || viewModel.action.name != nil {
//                HStack(alignment: .center, spacing: Constants.Design.spacing) {
//                    TextField ("action.edit.reps.name", text: viewModel.nameBinding)
//                        .disableAutocorrection(true)
//                        .padding(Constants.Design.spacing / 2)
//                    
//                    IconButton(
//                        systemImage: "xmark.circle",
//                        style: .inline,
//                        action: {
//                            withAnimation(.easeInOut(duration: 0.2)) {
//                                viewModel.clearName()
//                                isActionNameFieldEnabled = false
//                            }
//                        }
//                    )
//                }
//            } else {
//                Button(action: {
//                    withAnimation(.easeInOut(duration: 0.2)) {
//                        isActionNameFieldEnabled = true
//                    }
//                }) {
//                    Text("action.edit.reps.name.add.button")
//                        .padding(Constants.Design.spacing / 2)
//                }
//            }
//        }
//    }
//    
//    private var buttonStackView: some View {
//        HStack(alignment: .bottom, spacing: Constants.Design.spacing) {
//            Button(action: {
////                onDiscard()
//            }) {
//                Text("app.button.cancel.label")
//                    .secondaryButtonLabelStyleModifier()
//            }
//            Button(action: {
////                onSave(duration)
//            }) {
//                Text("app.button.save.label")
//                    .bold()
//                    .primaryButtonLabelStyleModifier()
//            }
//        }
//        .frame(maxWidth: .infinity, alignment: .trailing)
//    }
//    
//    private var isRepMaxShown: Bool {
//        true
//        
////        viewModel.action.repsMax > 0 || isRepMaxFieldEnabled
//    }
//    
//    private var isMaximumRepetionsSelected: Bool {
//        !viewModel.isMaxRepBinding.wrappedValue
//    }
//}
//
//
//
//struct DecimalTextField: View {
//    @Binding var value: Double
//    @State private var text: String = ""
//
//    var placeholder: String = ""
//    private let decimalSeparator = Locale.current.decimalSeparator ?? "."
//
//    var body: some View {
//        TextField(placeholder, text: textBinding)
//            .keyboardType(.decimalPad)
//            .onAppear { text = formatted(value) }
//    }
//
//    private var textBinding: Binding<String> {
//        Binding<String>(
//            get: { text },
//            set: { newText in
//                var filtered = newText.filter { $0.isNumber || String($0) == decimalSeparator }
//                if filtered.filter({ String($0) == decimalSeparator }).count > 1 {
//                    var seen = 0
//                    filtered = filtered.filter {
//                        if String($0) == decimalSeparator {
//                            seen += 1
//                            return seen <= 1
//                        }
//                        return true
//                    }
//                }
//
//                text = filtered
//
//                let normalized = text.replacingOccurrences(of: decimalSeparator, with: ".")
//                if let parsed = Double(normalized) {
//                    value = parsed
//                }
//            }
//        )
//    }
//
//    private func formatted(_ value: Double) -> String {
//        let str = String(value)
//        if str.hasSuffix(".0") {
//            return String(str.dropLast(2))
//        }
//        return str
//    }
//}
//
//struct RepsActionEditView_Preview : PreviewProvider {
//    static var previews: some View {
//        let persistenceController = PersistenceController.preview
//        let viewModel = RepsActionEditViewModel(context: persistenceController.container.viewContext)
//
//        RepsActionEditView(viewModel: viewModel)
//    }
//}
//
//
//import CoreData
//
//final class RepsActionEditViewModel: ObservableObject {
//    @Published private(set) var action: RepsActionEntity
//    let mainContext: NSManagedObjectContext
//    
//    var repsMinBinding: Binding<Int> {
//        .init(
//            get: { self.action.repsMin.intValue ?? 1 },
//            set: {
//                self.action.repsMin = NSNumber(value: $0)
//                self.objectWillChange.send()
//            }
//        )
//    }
//    
//    var repsMaxBinding: Binding<Int?> {
//        .init(
//            get: { self.action.repsMax.intValue },
//            set: {
//                self.action.repsMax = NSNumber(value: $0)
//                self.objectWillChange.send()
//            }
//        )
//    }
//    
//    var isMaxRepBinding: Binding<Bool> {
//        .init(
//            get: { self.action.isMax },
//            set: {
//                self.action.isMax = $0
//                self.objectWillChange.send()
//            }
//        )
//    }
//    
//    var nameBinding: Binding<String> {
//        .init(
//            get: { self.action.name ?? "" },
//            set: {
//                self.action.name = $0
//                self.objectWillChange.send()
//            }
//        )
//    }
//    
//    init(context: NSManagedObjectContext) {
//        self.mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
//        self.mainContext.parent = context
//        
//        self.action = RepsActionEntity(context: mainContext)
////        self.action.name = "NAME"
////        self.action.position = 1
////        self.action = fetchCollection(with: collectionUUID)
//        
////        refreshData()
//    }
//    
//    func getPosition() -> Int {
//
//        return Int(action.position)
//    }
//    
//    func clearName() {
//        action.name = nil
//        objectWillChange.send()
//    }
//}
//
//extension NSNumber? {
//    var intValue: Int? {
//        guard let self else { return nil }
//        return self as? Int
//    }
//}

import SwiftUI
import CoreData

struct TestExerciseAddView: View {
    let context: NSManagedObjectContext
    
    var body: some View {
        Button(action: {
            print("\n\n")
            let workout = WorkoutEntity(context: context)
            workout.uuid = UUID()
            workout.name = ""
            workout.position = 0

            print(workout)
            
            let exercise = ExerciseEntity(context: context)
            exercise.position = 0
            print(exercise)
            workout.addToExercises(exercise)
            print("\n\n")
            print(workout)
        }) {
            Text("AAA")
        }
    }
}

#Preview {
    TestExerciseAddView(context: PersistenceController.preview.container.viewContext)
}
