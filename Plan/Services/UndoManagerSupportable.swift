//
//  UndoManagerSupportable.swift
//  Plan
//
//  Created by Anton Cherkasov on 21.09.2024.
//

import Foundation

protocol UndoManagerSupportable {

	func canUndo() -> Bool

	func canRedo() -> Bool

	func redo()

	func undo()
}
