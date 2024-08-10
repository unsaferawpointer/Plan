//
//  PlanInteractor.swift
//  Plan
//
//  Created by Anton Cherkasov on 10.08.2024.
//

import Foundation

protocol PlanInteractorProtocol {

	func fetchData()

	func createNew(with text: String, in target: UUID?) -> UUID
	func deleteItems(_ ids: [UUID])
	func setState(_ flag: Bool, withSelection selection: [UUID])
	func setBookmark(_ flag: Bool, withSelection selection: [UUID])
	func setEstimation(_ value: Int, withSelection selection: [UUID])
	func setIcon(_ value: String?, withSelection selection: [UUID])

	func move(ids: [UUID], to destination: HierarchyDestination<UUID>)
	func validateMoving(ids: [UUID], to destination: HierarchyDestination<UUID>) -> Bool
	func insert(_ nodes: [TransferNode], to destination: HierarchyDestination<UUID>)

	func textDidChange(_ id: UUID, newText: String)
	func statusDidChange(_ id: UUID, newValue: Bool)

	func canUndo() -> Bool
	func canRedo() -> Bool
	func redo()
	func undo()
}

final class PlanInteractor {

	private let storage: DocumentStorage<HierarchyContent>

	weak var presenter: ListPresenterProtocol?

	init(storage: DocumentStorage<HierarchyContent>) {
		self.storage = storage
		storage.addObservation(for: self) { [weak self] _, content in
			guard let self else {
				return
			}
			self.presenter?.present(content)
		}
	}
}

// MARK: - PlanInteractorProtocol
extension PlanInteractor: PlanInteractorProtocol {

	func fetchData() {
		presenter?.present(storage.state)
	}

	func createNew(with text: String, in target: UUID?) -> UUID {
		let identifier = UUID()
		let itemContent = ItemContent(uuid: identifier, text: text)
		let destination: HierarchyDestination = if let target {
			.onItem(with: target)
		} else {
			.toRoot
		}
		storage.modificate { content in
			content.insertItems(with: [itemContent], to: destination)
		}
		return identifier
	}

	func deleteItems(_ ids: [UUID]) {
		storage.modificate { content in
			content.deleteItems(ids)
		}
	}

	func setState(_ flag: Bool, withSelection selection: [UUID]) {
		storage.modificate { content in
			content.setStatus(flag, for: selection)
		}
	}

	func setBookmark(_ flag: Bool, withSelection selection: [UUID]) {
		storage.modificate { content in
			content.setFavoriteFlag(flag, for: selection)
		}
	}

	func setEstimation(_ value: Int, withSelection selection: [UUID]) {
		storage.modificate { content in
			content.setEstimation(value, for: selection)
		}
	}

	func setIcon(_ value: String?, withSelection selection: [UUID]) {
		storage.modificate { content in
			content.setIcon(value, for: selection)
		}
	}



	func move(ids: [UUID], to destination: HierarchyDestination<UUID>) {
		storage.modificate { content in
			content.moveItems(with: ids, to: destination)
		}
	}

	func validateMoving(ids: [UUID], to destination: HierarchyDestination<UUID>) -> Bool {
		return storage.state.validateMoving(ids, to: destination)
	}

	func insert(_ nodes: [TransferNode], to destination: HierarchyDestination<UUID>) {
		storage.modificate { content in
			content.insertItems(from: nodes, to: destination)
		}
	}


	func textDidChange(_ id: UUID, newText: String) {
		storage.modificate { content in
			content.setText(newText, for: id)
		}
	}

	func statusDidChange(_ id: UUID, newValue: Bool) {
		storage.modificate { content in
			content.setStatus(newValue, for: [id])
		}
	}


	func canUndo() -> Bool {
		storage.canUndo()
	}

	func canRedo() -> Bool {
		storage.canRedo()
	}

	func redo() {
		storage.redo()
	}

	func undo() {
		storage.undo()
	}
}
