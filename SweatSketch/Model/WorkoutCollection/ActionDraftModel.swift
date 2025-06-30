//
//  Draft.swift
//  SweatSketch
//
//  Created by aibaranchikov on 30.06.2025.
//

import SwiftUICore

class ActionDraftModel: ObservableObject {
    var entityUUID: UUID?
    var entityKind: ActionKind?
    
    @Published var name: String
    @Published var kind: ActionKind
    @Published var sets: Int
    @Published var minValue: Double
    @Published var maxValue: Double?
    @Published var unit: LengthUnit?
    @Published var isMax: Bool
    @Published var position: Int
    
    init?(from entity: ExerciseActionEntity, lengthSystem: LengthSystem) {
        entityUUID = entity.uuid
        name = entity.name ?? ""
        sets = entity.sets.int
        isMax = entity.isMax
        position = entity.position.int
        
        switch entity {
        case let reps as RepsActionEntity:
            kind = .reps
            minValue  = Double(reps.repsMin)
            maxValue  = reps.repsMax.doubleValue
            unit = lengthSystem.defaultUnit
            print("\(type(of: self)): \(#function). Creating draft for reps action: \(reps.repsMin), \(String(describing: reps.repsMax)). Current draft values: \(minValue), \(String(describing: maxValue))")
            
        case let t as TimedActionEntity:
            kind = .timed
            minValue = Double(t.secondsMin)
            maxValue = t.secondsMax.doubleValue
            unit = lengthSystem.defaultUnit
            print("\(type(of: self)): \(#function). Creating draft for timed action: \(t.secondsMin), \(String(describing: t.secondsMax)). Current draft values: \(minValue), \(String(describing: maxValue))")
            
        case let d as DistanceActionEntity:
            kind = .distance
            let storedUnit = {
                if let dUnit = d.unit {
                    return LengthUnit(rawValue: dUnit) ?? .meters
                }
                return .meters
            }()
            if lengthSystem.allowedUnits.contains(storedUnit) {
                self.unit = storedUnit
                minValue = d.distanceMin
                maxValue = d.distanceMax?.doubleValue
            } else {
                minValue = d.distanceMin.converted(from: storedUnit, to: lengthSystem.defaultUnit)
                maxValue = {
                    if let dMax = d.distanceMax?.doubleValue {
                        return dMax.converted(from: storedUnit, to: lengthSystem.defaultUnit)
                    } else {
                        return nil
                    }
                }()
                self.unit = lengthSystem.defaultUnit
            }
            print("\(type(of: self)): \(#function). Creating draft for distance action: \(d.distanceMin), \(String(describing: d.distanceMax)). Current draft values: \(minValue), \(String(describing: maxValue))")
            
        case let rest as RestActionEntity:
            kind = .rest
            minValue = Double(rest.duration)
        default:
            return nil
        }
        
        entityKind = kind
    }
    
    init(position: Int) {
        self.entityUUID = nil
        self.entityKind = nil
        self.name = ""
        self.kind = .reps
        self.minValue = 1
        self.sets = 1
        self.isMax = false
        self.position = position
    }
}

import CoreData
import SwiftUICore

extension RepsActionEntity {
    convenience init(from draft: ActionDraftModel, in context: NSManagedObjectContext) {
        self.init(context: context)
        update(from: draft)
    }
    
    func update(from draft: ActionDraftModel) {
        self.name = draft.name
        self.sets = draft.sets.int16
        self.repsMin = Int16(draft.minValue.rounded())
        self.repsMax = draft.maxValue?.nsNumber
        self.isMax = draft.isMax
        self.position = draft.position.int16
    }
}

extension TimedActionEntity {
    convenience init(from draft: ActionDraftModel, in context: NSManagedObjectContext) {
        self.init(context: context)
        update(from: draft)
    }
    
    func update(from draft: ActionDraftModel) {
        self.name = draft.name
        self.sets = draft.sets.int16
        self.secondsMin = Int32(draft.minValue.rounded())
        self.secondsMax = draft.maxValue?.nsNumber
        self.isMax = draft.isMax
        self.position = draft.position.int16
    }
}

extension DistanceActionEntity {
    convenience init(from draft: ActionDraftModel, in context: NSManagedObjectContext) {
        self.init(context: context)
        update(from: draft)
    }
    
    func update(from draft: ActionDraftModel) {
        self.name = draft.name
        self.sets = draft.sets.int16
        self.distanceMin = draft.minValue.rounded()
        self.distanceMax = draft.maxValue?.nsNumber
        self.unit = draft.unit?.rawValue
        self.isMax = draft.isMax
        self.position = draft.position.int16
    }
}
