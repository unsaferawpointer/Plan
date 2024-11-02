//
//  HierarchyPresenter+HierarchyDropDelegate.swift
//  Plan
//
//  Created by Anton Cherkasov on 12.08.2024.
//

import Foundation

// MARK: - HierarchyDropDelegate
extension HierarchyPresenter: HierarchyDropDelegate {

	func move(ids: [UUID], to destination: HierarchyDestination<UUID>) {
		let globalDestination = destination.relative(to: rootIdentifier())
		interactor?.move(ids: ids, to: globalDestination)
	}

	func validateMoving(ids: [UUID], to destination: HierarchyDestination<UUID>) -> Bool {
		let globalDestination = destination.relative(to: rootIdentifier())
		return interactor?.validateMoving(ids: ids, to: globalDestination) ?? false
	}

	func write(ids: [UUID], to pasteboard: PasteboardFacadeProtocol) {
		let nodes = interactor?.nodes(ids) ?? []
		self.pasteboard.write(nodes, to: pasteboard, clearContents: false)
	}

	func insert(from pasteboard: PasteboardFacadeProtocol, to destination: HierarchyDestination<UUID>) {

		let globalDestination = destination.relative(to: rootIdentifier())

		let nodes = self.pasteboard.readNodes(from: pasteboard)

		guard !nodes.isEmpty else {

			let texts = self.pasteboard.readTexts(from: pasteboard)
			interactor?.insert(texts: texts, to: globalDestination)
			return
		}
		interactor?.insert(nodes, to: globalDestination)
	}
}

// MARK: - Helpers
extension HierarchyPresenter {

	func insertNodes(_ nodes: [TransferNode], to destination: HierarchyDestination<UUID>) {
		interactor?.insert(nodes, to: destination)
	}

	func insertTexts(_ texts: [String], to destination: HierarchyDestination<UUID>) {
		guard !texts.isEmpty else {
			return
		}
		interactor?.insert(texts: texts, to: destination)
	}

}
