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

		let isCompleted = storage.state.hierarchy.allSatisfy(\.isDone, equalsTo: true)

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

	func makeNode(_ entity: Node<ItemContent>) -> TransferNode {
		return TransferNode(value: entity.value, children: entity.children.map({ node in
			makeNode(node)
		}))
	}

	func makeSnapshot() -> HierarchySnapshot {
		let items = storage.state.hierarchy.nodes
		return HierarchySnapshot(items) { entity in

			let isDone = entity.reduce(\.isDone)
			let isFavorite = entity.value.isFavorite

			let isLeaf = entity.children.count == 0
			let icon = entity.value.iconName

			let menu = MenuItem(
				state:
					[
						"set_status_menu_item" : isDone ? .on : .off,
						"bookmark_menu_item" : isFavorite ? .on : .off
					],
				validation:
					[
						"set_status_menu_item" : true,
						"bookmark_menu_item": true,
						"delete_menu_item": true,
						"set_estimation_menu_item": isLeaf
					]
			)

			let style = makeStyle(
				isDone: isDone,
				isFavorite: isFavorite,
				icon: icon,
				isLeaf: isLeaf
			)

			let provider = { [weak self] (identifier: UUID) -> TransferNode? in
				return self?.makeNode(entity)
			}

			let status = entity.reduce(\.isDone)
			let number = entity.reduce(\.count)

			let textColor: HierarchyModel.Color = isDone ? .secondary : .primary

			let content: HierarchyModel.Content = .init(
				isOn: status,
				text: entity.value.text, 
				textColor: textColor,
				style: style,
				number: number
			)

			return HierarchyModel(
				uuid: entity.value.uuid,
				content: content,
				menu: menu,
				provider: provider
			)
		}
	}
}

extension ListPresenter {

	func makeStyle(isDone: Bool, isFavorite: Bool, icon: String?, isLeaf: Bool) -> HierarchyModel.Style {

		guard !isLeaf else {
			return .checkbox
		}

		switch (isDone, isFavorite) {
		case (true, true):
			return .icon(icon ?? "doc.text", color: .secondary)
		case (true, false):
			return .icon(icon ?? "doc.text", color: .secondary)
		case (false, true):
			return .icon("star.fill", color: .yellow)
		case (false, false):
			return .icon(icon ?? "doc.text", color: .primary)
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
