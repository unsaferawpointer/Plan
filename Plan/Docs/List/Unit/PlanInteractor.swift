//
//  PlanInteractor.swift
//  Plan
//
//  Created by Anton Cherkasov on 10.08.2024.
//

import Foundation

protocol PlanInteractorProtocol: UndoManagerSupportable {

	func fetchData()
	func node(_ id: UUID) -> any TreeNode<ItemContent>
	func nodes(_ ids: [UUID]) -> [any TreeNode<ItemContent>]

	func createNew(with text: String, in target: UUID?) -> UUID
	func deleteItems(_ ids: [UUID])
	func setState(_ flag: Bool, withSelection selection: [UUID])
	func setBookmark(_ flag: Bool, withSelection selection: [UUID])
	func setEstimation(_ value: Int, withSelection selection: [UUID])
	func setIcon(_ value: IconName?, withSelection selection: [UUID])

	func move(ids: [UUID], to destination: HierarchyDestination<UUID>)
	func validateMoving(ids: [UUID], to destination: HierarchyDestination<UUID>) -> Bool
	func insert(_ nodes: [any TreeNode<ItemContent>], to destination: HierarchyDestination<UUID>)
	func insert(texts: [String], to destination: HierarchyDestination<UUID>)

	func modificate(_ id: UUID, newText: String, newStatus: Bool)
	func modificate(_ id: UUID, newText: String)
}

final class PlanInteractor {

	private let storage: DocumentStorage<HierarchyContent>

	private let pasteboard: PasteboardFacadeProtocol

	weak var presenter: ListPresenterProtocol?

	var parser: TextParserProtocol

	// MARK: - Initialization

	init(
		storage: DocumentStorage<HierarchyContent>,
		pasteboard: PasteboardFacadeProtocol = PasteboardFacade(),
		parser: TextParserProtocol = TextParser(configuration: .default)
	) {
		self.storage = storage
		self.pasteboard = pasteboard
		self.parser = parser
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

	func node(_ id: UUID) -> any TreeNode<ItemContent> {
		storage.state.hierarchy[id]
	}

	func nodes(_ ids: [UUID]) -> [any TreeNode<ItemContent>] {
		storage.state.hierarchy.nodes(with: ids)
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

	func setIcon(_ value: IconName?, withSelection selection: [UUID]) {
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

	func insert(_ nodes: [any TreeNode<ItemContent>], to destination: HierarchyDestination<UUID>) {
		storage.modificate { content in
			content.insertItems(from: nodes, to: destination)
		}
	}

	func insert(texts: [String], to destination: HierarchyDestination<UUID>) {
		let nodes: [any TreeNode<ItemContent>] = texts.flatMap {
			parser.parse(from: $0)
		}
		storage.modificate { content in
			content.insertItems(from: nodes, to: destination)
		}
	}

	func modificate(_ id: UUID, newText: String, newStatus: Bool) {
		storage.modificate { content in
			content.setText(newText, for: id)
			content.setStatus(newStatus, for: [id])
		}
	}

	func modificate(_ id: UUID, newText: String) {
		storage.modificate { content in
			content.setText(newText, for: id)
		}
	}
}

// MARK: - UndoManagerSupportable
extension PlanInteractor: UndoManagerSupportable {

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
