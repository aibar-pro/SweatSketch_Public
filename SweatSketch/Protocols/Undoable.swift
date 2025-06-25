//
//  Undoable.swift
//  SweatSketch
//
//  Created by aibaranchikov on 24.06.2025.
//

import Foundation

protocol Undoable: AnyObject {
    var canUndo: Bool { get }
    var canRedo: Bool { get }
    func undo()
    func redo()
}
