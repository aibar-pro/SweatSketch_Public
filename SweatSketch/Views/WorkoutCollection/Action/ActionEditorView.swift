//
//  ActionEditorView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 27.06.2025.
//

import SwiftUI

enum PresetCatalog {
    static let reps: [(Int, Int?)] = [
        (4, 6),
        (8, 10),
        (12, 15)
    ]
    static let timed: [(Int, Int?)] = [
        (30, 60),
        (60, 90),
        (600, 1200)
    ]
    static let distance: [(Double, Double?, LengthUnit)] = [
        (100, 200, .meters),
        (400, 800, .meters),
        (8, 10, .kilometers),
        (0.25, 0.5, .miles)
    ]
}

struct ActionEditorView: View {
    //TODO: Move property to EnvironmentObj
    let appLengthSystem: LengthSystem = AppSettings.shared.lengthSystem
    
    @StateObject private var draft: ActionDraftModel
    @State private var selectedLengthUnit: LengthUnit
    
    var onSubmit: (ActionDraftModel) -> Void
    var onCancel: () -> Void
    
    init(
        draft: ActionDraftModel,
        onSubmit: @escaping (ActionDraftModel) -> Void,
        onCancel: @escaping () -> Void
    ) {
        _draft = StateObject(wrappedValue: draft)
        _selectedLengthUnit = .init(initialValue: draft.unit ?? appLengthSystem.defaultUnit)
        self.onSubmit = onSubmit
        self.onCancel = onCancel
    }
    
    var body: some View {
        actionForm
    }
    
    let formWidth: CGFloat = 300
    
    private var actionForm: some View {
        VStack(alignment: .leading, spacing: Constants.Design.spacing * 2) {
            Picker("", selection: $draft.kind) {
                ForEach(ActionKind.allCases.filter(\.isNonRest), id: \.self) {
                    Text($0.localizedTitle).tag($0)
                        .adaptiveForegroundStyle(Constants.Design.Colors.elementFgMediumEmphasis)
                }
            }
            .pickerStyle(.segmented)
            
            nameField
            
            FormField(title: "action.edit.sets.label", contentMaxWidth: formWidth / 4) {
                IntegerTextField(
                    value: $draft.sets,
                    placeholder: ""
                )
            }
            
            ChipsRow(chips: chips(for: draft.kind))
            
            
            Group {
                HStack(alignment: .lastTextBaseline, spacing: Constants.Design.spacing) {
                    Group {
                        minValueField
                        Text("-")
                        maxValueField
                        
                        unitField
                    }
                    .opacity(draft.isMax ? 0.33 : 1)
                    .contentShape(Rectangle())
                    .simultaneousGesture(
                        TapGesture().onEnded { _ in
                            if draft.isMax {
                                draft.isMax.toggle()
                            }
                        }
                    )
                    
                }
                
                isMaxSwitch
            }
            
            buttonStackView
        }
    }

    private var nameField: some View {
        FormField(title: "action.edit.name.label") {
            TextField("", text: $draft.name)
        }
    }
    
    private var minValueField: some View {
        FormField(title: "action.edit.min.label", contentMaxWidth: formWidth / 4) {
            Group {
                switch draft.kind {
                case .distance:
                    DecimalTextField(
                        value: $draft.minValue,
                        placeholder: ""
                    )
                default:
                    IntegerTextField(
                        value: $draft.minValue.asInt(),
                        placeholder: ""
                    )
                }
            }
        }
    }
    
    private var maxValueField: some View {
        FormField(title: "action.edit.max.label", contentMaxWidth: formWidth / 4) {
            Group {
                switch draft.kind {
                case .distance:
                    DecimalTextField(
                        value: $draft.maxValue.or(draft.minValue),
                        placeholder: ""
                    )
                default:
                    IntegerTextField(
                        value: $draft.maxValue.or(draft.minValue).asInt(),
                        placeholder: ""
                    )
                }
            }
        }
    }
    
    private var unitField: some View {
        return Group {
            switch draft.kind {
            case .distance:
                Picker("", selection: $draft.unit) {
                    ForEach(appLengthSystem.allowedUnits, id: \.id) { unit in
                        Text(unit.localizedName).tag(unit)
                    }
                }
                .pickerStyle(.menu)
                .adaptiveTint(Constants.Design.Colors.elementFgHighEmphasis)
                .onReceive(draft.$unit.compactMap{ $0 }) { newValue in
                    draft.minValue = draft.minValue.converted(from: selectedLengthUnit, to: newValue)
                    if let maxValue = draft.maxValue {
                        draft.maxValue = maxValue.converted(from: selectedLengthUnit, to: newValue)
                    }
                    selectedLengthUnit = newValue
                }
            case .timed:
                Text(TimeUnit.second.localizedShortDescription)
            default:
                EmptyView()
            }
        }
    }
    
    private var isMaxSwitch: some View {
        FormField(title: "action.edit.or.label", contentMaxWidth: formWidth * 0.67) {
            Toggle("action.edit.isMax.label", isOn: $draft.isMax)
                .adaptiveTint(Constants.Design.Colors.elementFgPrimary)
        }
    }
    
    private var buttonStackView: some View {
        HStack(spacing: Constants.Design.spacing) {
            RectangleButton(
                "app.button.cancel.label",
                style: .inline,
                action: {
//                    text.removeAll()
                    onCancel()
                }
            )
            
            RectangleButton(
                "app.button.save.label",
                style: .primary,
//                isDisabled: Binding { text.isEmpty } set: { _ in },
                action: {
                    onSubmit(draft)
                }
            )
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

extension ActionEditorView {
    private func chips(for kind: ActionKind) -> [QuickChip] {
        switch kind {
        case .reps:
            return PresetCatalog.reps.map { min, max in
                QuickChip(label: min.rangeString(to: max)) {
                    draft.minValue = Double(min)
                    draft.maxValue = max.map(Double.init)
                }
            }
        case .timed:
            return PresetCatalog.timed.map { min, max in
                QuickChip(
                    label: min.rangeString(
                        to: max,
                        unit: TimeUnit.second.localizedShortDescription.stringValue()
                    )
                ) {
                    draft.minValue = Double(min)
                    draft.maxValue = max.map(Double.init)
                }
            }
        case .distance:
            return PresetCatalog.distance
                .filter { AppSettings.shared.lengthSystem.allowedUnits.contains($0.2) }
                .map { min, max, unit in
                    QuickChip(
                        label: min.rangeString(
                            to: max,
                            unit: unit.localizedName
                        )
                    ) {
                        draft.unit = unit
                        draft.minValue = min.converted(from: unit, to: selectedLengthUnit)
                        draft.maxValue = max?.converted(from: unit, to: selectedLengthUnit)
                    }
                }
        default:
            return []
        }
    }
}

struct ActionEditorView_Previews: PreviewProvider {
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
        
        let draft = ActionDraftModel(from: action, lengthSystem: .imperial)!
        
        ActionEditorView(
            draft: draft,
            onSubmit: { _ in },
            onCancel: {}
        )
    }
}

