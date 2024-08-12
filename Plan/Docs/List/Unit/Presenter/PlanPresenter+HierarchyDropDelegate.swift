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

	func insert(_ nodes: [TransferNode], to destination: HierarchyDestination<UUID>) {
		interactor?.insert(nodes, to: destination)
	}

	func insert(_ texts: [String], to destination: HierarchyDestination<UUID>) {
		interactor?.insert(texts: texts, to: destination)
	}
}
