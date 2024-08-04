//
//  HierarchySnapshot.swift
//  Hierarchy
//
//  Created by Anton Cherkasov on 29.09.2023.
//

import Foundation

struct HierarchySnapshot {

	typealias ID = Model.ID

	typealias Model = HierarchyModel

	private(set) var root: [Model] = []

	private(set) var storage: [ID: [Model]] = [:]

	private(set) var cache: [ID: Model] = [:]

	private(set) var identifiers: Set<ID> = .init()

	// MARK: - Initialization

	init(_ base: [Node<ItemContent>], transform: (Node<ItemContent>) -> Model) {
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

	mutating func makeItem(base: Node<ItemContent>, transform: (Node<ItemContent>) -> Model) -> Model {

		let item = transform(base)

		// Store in cache
		identifiers.insert(item.id)
		cache[item.id] = item

		storage[base.id] = base.children.map { entity in
			makeItem(base: entity, transform: transform)
		}
		return item
	}
}
