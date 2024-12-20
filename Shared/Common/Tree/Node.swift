//
//  Node.swift
//  Hierarchy
//
//  Created by Anton Cherkasov on 28.10.2023.
//

import Foundation

final class Node<Value: NodeValue>: TreeNode {

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

// MARK: - Helpers
private extension Node {

	/// Visit node by depth first traversal
	func visit(_ node: Node, block: (Node) -> Void) {
		block(node)
		node.children.forEach {
			visit($0, block: block)
		}
	}
}

// MARK: - Identifiable
extension Node: Identifiable {

	var id: Value.ID {
		return value.id
	}
}

// MARK: - Public interface
extension Node {

	func generateIdentifier() {
		value.generateIdentifier()
	}

	func enumerateBackwards(_ block: (Node) -> Void) {
		block(self)
		parent?.enumerateBackwards(block)
	}

	func count<T: Equatable>(where keyPath: KeyPath<Value, T>, equalsTo value: T) -> Int {
		guard !children.isEmpty else {
			return self.value[keyPath: keyPath] == value ? 1 : 0
		}
		return children.reduce(0) { partialResult, node in
			return partialResult + node.count(where: keyPath, equalsTo: value)
		}
	}

	func childrenIds() -> [ID] {
		var result = children.map(\.id)
		for child in children {
			result.append(contentsOf: child.childrenIds())
		}
		return result
	}

	func isAncestor(of other: ID) -> Bool {
		guard children.contains(where: { $0.id == other }) else {
			for child in children {
				if child.isAncestor(of: other) {
					return true
				}
			}
			return false
		}
		return true
	}

	func setProperty<T>(_ keyPath: WritableKeyPath<Value, T>, to value: T, downstream: Bool) {
		self.value[keyPath: keyPath] = value
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

	@discardableResult
	func deleteChild(_ id: ID) -> Int? {
		guard let index = children.firstIndex(where: \.id, equalsTo: id) else {
			return nil
		}
		children.remove(at: index)
		return index
	}

	func insertItems(with items: [Node], to index: Int) {
		self.children.insert(contentsOf: items, at: index)
		items.forEach { item in
			item.parent = self
		}
	}

	func appendItems(with items: [Node]) {
		self.children.append(contentsOf: items)
		items.forEach { item in
			item.parent = self
		}
	}
}

// MARK: - Nested data structs
extension Node {

	enum CodingKeys: CodingKey {
		case value
		case children
	}
}

// MARK: - Hashable
extension Node: Hashable {

	static func == (lhs: Node<Value>, rhs: Node<Value>) -> Bool {
		return lhs.id == rhs.id 
				&& lhs.value == rhs.value
				&& lhs.children == rhs.children
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
		hasher.combine(value)
	}
}

// MARK: - Decodable
extension Node: Decodable where Value: Decodable {

	convenience init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		let value = try container.decode(Value.self, forKey: .value)
		let children = try container.decodeIfPresent([Node].self, forKey: .children) ?? []

		self.init(value: value, children: children)
	}
}

// MARK: - Encodable
extension Node: Encodable where Value: Encodable {

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		try container.encode(value, forKey: .value)
		try container.encode(children, forKey: .children)
	}
}
