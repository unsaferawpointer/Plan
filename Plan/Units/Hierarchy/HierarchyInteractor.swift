//
//  HierarchyInteractor.swift
//  Plan
//
//  Created by Anton Cherkasov on 10.08.2024.
//

import Foundation

protocol HierarchyInteractorProtocol: UndoManagerSupportable {

	func fetchData()
	func node(_ id: UUID) -> any TreeNode<ItemContent>
	func nodes(_ ids: [UUID]) -> [any TreeNode<ItemContent>]

	func createNew(with text: String, destination: HierarchyDestination<UUID>) -> UUID
	func deleteItems(_ ids: [UUID])
	func setState(_ flag: Bool, withSelection selection: [UUID])
	func setBookmark(_ flag: Bool, withSelection selection: [UUID])
	func setPriority(_ value: ItemPriority, withSelection selection: [UUID])
	func setNumber(_ value: Int, withSelection selection: [UUID])
	func setIcon(_ value: IconName?, withSelection selection: [UUID])
	func setColor(_ value: ColorModel?, withSelection selection: [UUID])

	func move(ids: [UUID], to destination: HierarchyDestination<UUID>)
	func validateMoving(ids: [UUID], to destination: HierarchyDestination<UUID>) -> Bool
	func insert(_ nodes: [any TreeNode<ItemContent>], to destination: HierarchyDestination<UUID>)
	func insert(texts: [String], to destination: HierarchyDestination<UUID>)

	func modificate(_ id: UUID, newText: String, newStatus: Bool)
	func modificate(_ id: UUID, newText: String)
}

final class HierarchyInteractor {

	private let storage: DocumentStorage<PlanContent>

	private let pasteboard: PasteboardFacadeProtocol

	weak var presenter: HierarchyPresenterProtocol?

	var parser: TextParserProtocol

	// MARK: - Initialization

	init(
		storage: DocumentStorage<PlanContent>,
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

// MARK: - HierarchyInteractorProtocol
extension HierarchyInteractor: HierarchyInteractorProtocol {

	func fetchData() {
		presenter?.present(storage.state)
	}

	func node(_ id: UUID) -> any TreeNode<ItemContent> {
		storage.state.hierarchy[id]
	}

	func nodes(_ ids: [UUID]) -> [any TreeNode<ItemContent>] {
		storage.state.hierarchy.nodes(with: ids)
	}

	func createNew(with text: String, destination: HierarchyDestination<UUID>) -> UUID {
		let identifier = UUID()
		let itemContent = ItemContent(uuid: identifier, text: text)
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
		modificate(ids: selection, keyPath: \.isDone, value: flag, downstream: true)
	}

	func setBookmark(_ flag: Bool, withSelection selection: [UUID]) {
		modificate(ids: selection, keyPath: \.isFavorite, value: flag)
	}

	func setPriority(_ value: ItemPriority, withSelection selection: [UUID]) {
		modificate(ids: selection, keyPath: \.priority, value: value)
	}

	func setNumber(_ value: Int, withSelection selection: [UUID]) {
		modificate(ids: selection, keyPath: \.count, value: value)
	}

	func setIcon(_ value: IconName?, withSelection selection: [UUID]) {
		modificate(ids: selection, keyPath: \.iconName, value: value)
	}

	func setColor(_ value: ColorModel?, withSelection selection: [UUID]) {
		modificate(ids: selection, keyPath: \.iconColor, value: value)
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
		let textModification = AnyModification(keyPath: \ItemContent.text, value: newText)
		let statustModification = AnyModification(keyPath: \ItemContent.isDone, value: newStatus)
		storage.modificate { content in
			content.perform(textModification, for: [id])
			content.perform(statustModification, for: [id])
		}
	}

	func modificate(_ id: UUID, newText: String) {
		modificate(ids: [id], keyPath: \.text, value: newText)
	}
}

// MARK: - UndoManagerSupportable
extension HierarchyInteractor: UndoManagerSupportable {

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

// MARK: - Helpers
private extension HierarchyInteractor {

	func modificate<T>(ids: [UUID], keyPath: WritableKeyPath<ItemContent, T>, value: T, downstream: Bool = false) {
		let modification = AnyModification(keyPath: keyPath, value: value)
		storage.modificate { content in
			content.perform(
				modification,
				for: ids,
				downstream: downstream
			)
		}
	}

}
