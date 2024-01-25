//
//  Node.swift
//  Plan
//
//  Created by Anton Cherkasov on 20.01.2024.
//

import Foundation

protocol TreeNode: AnyObject {
	var parent: Self? { get }
	var children: [Self] { get }
}

extension TreeNode {

	func setProperty<T>(_ keyPath: ReferenceWritableKeyPath<Self, T>, to value: T, downstream: Bool) {
		self[keyPath: keyPath] = value
		if downstream {
			children.forEach { item in
				item.setProperty(
					keyPath,
					to: value,
					downstream: downstream
				)
			}
		}
	}

	/// Visit node by depth first traversal
	func visit(_ node: Self, block: (Self) -> Void) {
		block(node)
		node.children.forEach {
			visit($0, block: block)
		}
	}
}

final class Node<Value: Identifiable>: TreeNode {

	typealias ID = Value.ID

	var value: Value

	// MARK: - Relationships

	weak var parent: Node?

	var children: [Node]

	// MARK: - Initialization

	init(value: Value, children: [Node] = []) {
		self.value = value
		self.children = children
		for node in children {
			node.parent = self
		}
	}
}

// MARK: - Identifiable
extension Node: Identifiable {

	var id: Value.ID {
		return value.id
	}
}
