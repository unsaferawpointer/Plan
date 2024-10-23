//
//  ListUnitInteractor.swift
//  Plan
//
//  Created by Anton Cherkasov on 21.10.2024.
//

import Foundation

protocol ListUnitInteractorProtocol: UndoManagerSupportable {

	func fetchData()
	func node(_ id: UUID) -> any TreeNode<ItemContent>
	func nodes(_ ids: [UUID]) -> [any TreeNode<ItemContent>]

	func createNew(with text: String, in target: UUID?) -> UUID
	func deleteItems(_ ids: [UUID])
	func setState(_ flag: Bool, withSelection selection: [UUID])
	func setBookmark(_ flag: Bool, withSelection selection: [UUID])
	func setPriority(_ value: ItemPriority, withSelection selection: [UUID])
	func setNumber(_ value: Int, withSelection selection: [UUID])
	func setIcon(_ value: IconName?, withSelection selection: [UUID])
	func setColor(_ value: Color?, withSelection selection: [UUID])

	func modificate(_ id: UUID, newStatus: Bool)
	func modificate(_ id: UUID, newText: String)
}

final class ListUnitInteractor {

	private let storage: DocumentStorage<PlanContent>

	weak var presenter: ListUnitPresenterProtocol?

	// MARK: - Initialization

	init(
		storage: DocumentStorage<PlanContent>
	) {
		self.storage = storage
		storage.addObservation(for: self) { [weak self] _, content in
			guard let self else {
				return
			}
			self.presenter?.present(content)
		}
	}
}

// MARK: - ListUnitInteractorProtocol
extension ListUnitInteractor: ListUnitInteractorProtocol {

	func fetchData() {
		presenter?.present(storage.state)
	}
	
	func node(_ id: UUID) -> any TreeNode<ItemContent> {
		fatalError()
	}
	
	func nodes(_ ids: [UUID]) -> [any TreeNode<ItemContent>] {
		fatalError()
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
		modificate(ids: selection, keyPath: \.isDone, value: flag)
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
	
	func setColor(_ value: Color?, withSelection selection: [UUID]) {
		modificate(ids: selection, keyPath: \.iconColor, value: value)
	}
	
	func modificate(_ id: UUID, newStatus: Bool) {
		modificate(ids: [id], keyPath: \.isDone, value: newStatus, downstream: true)
	}
	
	func modificate(_ id: UUID, newText: String) {
		modificate(ids: [id], keyPath: \.text, value: newText)
	}
	
	func canUndo() -> Bool {
		fatalError()
	}
	
	func canRedo() -> Bool {
		fatalError()
	}
	
	func redo() {
		fatalError()
	}
	
	func undo() {
		fatalError()
	}

}

// MARK: - Helpers
private extension ListUnitInteractor {

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
