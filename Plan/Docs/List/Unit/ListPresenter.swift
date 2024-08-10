//
//  ListPresenter.swift
//  Hierarchy
//
//  Created by Anton Cherkasov on 02.10.2023.
//

import Foundation

protocol ListPresenterProtocol {
	func deleteItems(_ ids: [UUID])
	func createNew(with selection: [UUID])
}

final class ListPresenter {

	var storage: DocumentStorage<HierarchyContent>

	weak var view: HierarchyView?

	var statusFactory: ListUnitStatusFactoryProtocol

	var modelFactory: ListModelFactoryProtocol

	init(
		storage: DocumentStorage<HierarchyContent>,
		statusFactory: ListUnitStatusFactoryProtocol = ListUnitStatusFactory(),
		modelFactory: ListModelFactoryProtocol = ListModelFactory()
	) {
		self.storage = storage
		self.statusFactory = statusFactory
		self.modelFactory = modelFactory
		storage.addObservation(for: self) { [weak self] _, content in
			guard let self else {
				return
			}
			let model = makeModel()
			self.view?.display(model)
		}
	}
}

// MARK: - ListPresenterProtocol
extension ListPresenter: ListViewOutput {

	func viewDidLoad() {
		view?.display(makeModel())
		view?.setConfiguration(
			DropConfiguration(types: [.id, .item])
		)
	}

	func deleteItems(_ ids: [UUID]) {
		storage.modificate { content in
			content.deleteItems(ids)
		}
	}

	func createNew(with selection: [UUID]) {
		let first = selection.first
		let id = UUID()
		let itemContent = ItemContent(uuid: id, text: "New item", isDone: false, iconName: nil, count: 0, options: [])
		let destination: HierarchyDestination = if let first {
			.onItem(with: first)
		} else {
			.toRoot
		}

		storage.modificate { content in
			content.insertItems(with: [itemContent], to: destination)
		}
		view?.scroll(to: id)
		if let first {
			view?.expand(first)
		}
		view?.focus(on: id)
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

extension ListPresenter {

	func makeModel() -> ListUnitModel {
		let snapshot = makeSnapshot()

		let status = statusFactory.makeModel(for: storage.state.hierarchy)

		let model: ListUnitModel = if !snapshot.root.isEmpty {
			.regular(snapshot: snapshot, status: status)
		} else {
			.placeholder(
				title: "No Items, yet",
				subtitle: "Add a new element using the plus."
			)
		}
		return model
	}

	func makeSnapshot() -> HierarchySnapshot {
		let items = storage.state.hierarchy.nodes
		return HierarchySnapshot(items) { item, info in
			modelFactory.makeModel(item: item, info: info)
		}
	}
}

// MARK: - HierarchyDropDelegate
extension ListPresenter: HierarchyDropDelegate {

	func move(ids: [UUID], to destination: HierarchyDestination<UUID>) {
		storage.modificate { content in
			content.moveItems(with: ids, to: destination)
		}
	}
	
	func validateMoving(ids: [UUID], to destination: HierarchyDestination<UUID>) -> Bool {
		return self.storage.state.validateMoving(ids, to: destination)
	}
	
	func insert(_ nodes: [TransferNode], to destination: HierarchyDestination<UUID>) {
		storage.modificate { content in
			content.insertItems(from: nodes, to: destination)
		}
	}
}

// MARK: - ListItemViewOutput
extension ListPresenter: ListItemViewOutput {

	func textfieldDidChange(_ id: UUID, newText: String) {
		storage.modificate { content in
			content.setText(newText, for: id)
		}
	}

	func checkboxDidChange(_ id: UUID, newValue: Bool) {
		storage.modificate { content in
			content.setStatus(newValue, for: [id])
		}
	}
}
