//
//  HierarchySnapshot.swift
//  Plan
//
//  Created by Anton Cherkasov on 20.01.2024.
//

import Foundation

struct HierarchySnapshot {

	typealias ID = Model.ID

	typealias Model = HierarchyTodoModel

	private(set) var root: [Model] = []

	private(set) var storage: [ID: [Model]] = [:]

	private(set) var cache: [ID: Model] = [:]

	private(set) var identifiers: Set<ID> = .init()

	// MARK: - Initialization

	init<T: TreeNode>(_ base: [Node<T>], transform: (T) -> Model) where T: Identifiable, T.ID == ID {
		self.root = base.map { container in
			makeItem(base: container, transform: transform)
		}
	}

	/// Initialize empty snapshot
	init() { }
}

// MARK: - Public interface
extension HierarchySnapshot {

	func rootItem(at index: Int) -> Model {
		return root[index]
	}

	func rootIdentifier(at index: Int) -> ID {
		return root[index].id
	}

	func numberOfRootItems() -> Int {
		return root.count
	}

	func numberOfChildren(ofItem id: ID) -> Int {
		guard let children = storage[id] else {
			fatalError()
		}
		return children.count
	}

	func childOfItem(_ id: ID, at index: Int) -> Model {
		guard let children = storage[id] else {
			fatalError()
		}
		return children[index]
	}

	func model(with id: ID) -> Model {
		return cache[unsafe: id]
	}
}

// MARK: - Helpers
private extension HierarchySnapshot {

	mutating func makeItem<T: TreeNode>(base: Node<T>, transform: (T) -> Model) -> Model where T: Identifiable, T.ID == ID {

		let item = transform(base.value)

		// Store in cache
		identifiers.insert(item.id)
		cache[item.id] = item

		storage[base.id] = base.children.map { entity in
			makeItem(base: entity, transform: transform)
		}
		return item
	}
}

extension HierarchySnapshot {

	static var empty: HierarchySnapshot {
		return .init()
	}
}
