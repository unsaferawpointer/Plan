//
//  PlanPresenter+HierarchyDropDelegate.swift
//  Plan
//
//  Created by Anton Cherkasov on 12.08.2024.
//

import Foundation

// MARK: - HierarchyDropDelegate
extension PlanPresenter: HierarchyDropDelegate {

	func move(ids: [UUID], to destination: HierarchyDestination<UUID>) {
		interactor?.move(ids: ids, to: destination)
	}

	func validateMoving(ids: [UUID], to destination: HierarchyDestination<UUID>) -> Bool {
		return interactor?.validateMoving(ids: ids, to: destination) ?? false
	}

	func insert(_ info: DropInfo, to destination: HierarchyDestination<UUID>) {
		let nodesData = info.items.compactMap {
			$0.data[.item]
		}

		guard !nodesData.isEmpty else {

			let texts = info.items.compactMap {
				$0.data[.string]
			}.compactMap {
				String(data: $0, encoding: .utf8)
			}
			insertTexts(texts, to: destination)
			return
		}

		let nodes = nodesData.compactMap {
			try? JSONDecoder().decode(TransferNode.self, from: $0)
		}
		insertNodes(nodes, to: destination)
	}

	func node(for id: UUID, selection: [UUID]) -> TransferNode {
		guard let interactor else {
			fatalError()
		}
		let anyNode = interactor.node(id)
		var transferNode = makeNode(anyNode)
		transferNode.delete(Set(selection))
		return transferNode
	}

	func item(for id: UUID, with other: [UUID]) -> DropInfo.Item {
		guard let interactor else {
			fatalError("Can`t find the interactor")
		}
		let node = interactor.node(id)

		var item = DropInfo.Item(data: [:])


		var transferNode = makeNode(node)
		transferNode.delete(Set(other))

		let text = formatter.format(nodes: [transferNode])

		if let data = text.data(using: .utf8) {
			item.data[.string] = data
		}

		if let data = try? JSONEncoder().encode(transferNode) {
			item.data[.item] = data
		}

		return item
	}
}

// MARK: - Helpers
private extension PlanPresenter {

	func insertNodes(_ nodes: [TransferNode], to destination: HierarchyDestination<UUID>) {
		interactor?.insert(nodes, to: destination)
	}

	func insertTexts(_ texts: [String], to destination: HierarchyDestination<UUID>) {
		guard !texts.isEmpty else {
			return
		}
		interactor?.insert(texts: texts, to: destination)
	}

	func makeNode(_ entity: any TreeNode<ItemContent>) -> TransferNode {
		return TransferNode(value: entity.value, children: entity.children.map({ node in
			makeNode(node)
		}))
	}
}
