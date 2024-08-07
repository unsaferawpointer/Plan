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

	init(
		storage: DocumentStorage<HierarchyContent>,
		statusFactory: ListUnitStatusFactoryProtocol = ListUnitStatusFactory()
	) {
		self.storage = storage
		self.statusFactory = statusFactory
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
		let model = makeModel()
		view?.display(model)
		view?.setConfiguration(makeDropConfiguration())
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

		let isCompleted = snapshot.root.map {
			$0.status
		}.allSatisfy {
			$0
		}

		let model: ListUnitModel = if !snapshot.root.isEmpty {
			.regular(snapshot: snapshot, status: statusFactory.makeModel(for: storage.state.hierarchy))
		} else {
			.placeholder(
				title: "No Items, yet",
				subtitle: "Add a new element using the plus."
			)
		}
		return model
	}

	func makeNode(_ entity: Node<ItemContent>) -> TransferNode {
		return TransferNode(value: entity.value, children: entity.children.map({ node in
			makeNode(node)
		}))
	}

	func makeDropConfiguration() -> DropConfiguration {
		var configuration = DropConfiguration()
		configuration.types = [.id, .item]
		return configuration
	}

	func makeSnapshot() -> HierarchySnapshot {
		let items = storage.state.hierarchy.nodes
		return HierarchySnapshot(items) { entity in
			let menu = MenuItem(
				state:
					[
						"set_status_menu_item" : entity.reduce(\.isDone) ? .on : .off,
						"bookmark_menu_item" : entity.value.isFavorite ? .on : .off
					],
				validation:
					[
						"set_status_menu_item" : true,
						"bookmark_menu_item": true,
						"delete_menu_item": true,
						"set_estimation_menu_item": entity.children.count == 0
					]
			)

			let style: HierarchyModel.Style = {
				if entity.children.count > 0 {
					if let name = entity.value.iconName {
						return .icon(name)
					} else {
						return .list
					}
				} else {
					return .checkbox
				}
			}()

			let provider = { [weak self] (identifier: UUID) -> TransferNode? in
				return self?.makeNode(entity)
			}

			return HierarchyModel(
				uuid: entity.value.uuid,
				status: entity.reduce(\.isDone),
				text: entity.value.text,
				style: style,
				isFavorite: entity.value.options.contains(.favorite),
				number: entity.reduce(\.count),
				menu: menu,
				animateIcon: false,
				provider: provider
			)
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
