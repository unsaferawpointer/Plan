//
//  DocumentStorage.swift
//  Hierarchy
//
//  Created by Anton Cherkasov on 27.09.2023.
//

import Foundation

final class DocumentStorage<State: AnyObject> {

	private(set) var provider: any ContentProvider<State>

	private var observations = [(State) -> Bool]()

	private (set) var state: State

	// MARK: - Undo Manager

	private (set) var undoManager: UndoManager?

	// MARK: - Initialization

	/// Basic initialization
	///
	/// - Parameters:
	///    - initialState: Initial state
	///    - provider: Document file data provider
	///    - undoManager: Document undo manager
	init(initialState: State, provider: any ContentProvider<State>, undoManager: UndoManager?) {
		self.state = initialState
		self.provider = provider
		self.undoManager = undoManager
	}
}

// MARK: - DocumentDataPublisher
extension DocumentStorage: DocumentDataPublisher {

	func modificate(_ block: (State) -> Void) {
		performOperation(block)
	}

	func addObservation<O: AnyObject>(
		for object: O,
		handler: @escaping (O, State) -> Void
	) {

		handler(object, state)

		// Each observation closure returns a Bool that indicates
		// whether the observation should still be kept alive,
		// based on whether the observing object is still retained.
		observations.append { [weak object] value in
			guard let object = object else {
				return false
			}

			handler(object, value)
			return true
		}
	}
}

// MARK: - DocumentDataRepresentation
extension DocumentStorage: DocumentDataRepresentation {

	func data(ofType typeName: String) throws -> Data {
		try provider.data(ofType: typeName, content: state)
	}

	func read(from data: Data, ofType typeName: String) throws {
		self.state = try provider.read(from: data, ofType: typeName)
		observations = observations.filter { $0(state) }
		undoManager?.removeAllActions()
	}
}

// MARK: - Undo manager support
extension DocumentStorage {

	func canRedo() -> Bool {
		return undoManager?.canRedo ?? true
	}

	func redo() {
		undoManager?.redo()
	}

	func canUndo() -> Bool {
		return undoManager?.canUndo ?? false
	}

	func undo() {
		undoManager?.undo()
	}
}

// MARK: - Helpers
private extension DocumentStorage {

	func performOperation(with newData: Data, oldData: Data, oppositeOperation: Bool) {
		undoManager?.registerUndo(withTarget: self) { [weak self] target in
			self?.performOperation(with: oldData, oldData: newData, oppositeOperation: true)
		}
		if oppositeOperation {
			guard let content = try? provider.read(from: newData) else {
				return
			}
			self.state = content
		}
		observations = observations.filter { $0(state) }
	}

	func performOperation(_ block: (State) -> Void) {
		let oldData = try? provider.data(of: state)
		block(state)
		let newData = try? provider.data(of: state)
		guard let oldData, let newData else {
			return
		}
		performOperation(with: newData, oldData: oldData, oppositeOperation: false)
	}
}
