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

	// MARK: - Hierarchy

	private(set) var root: [ID] = []

	private(set) var storage: [ID: [ID]] = [:]

	// MARK: - Cache

	private(set) var cache: [ID: Model] = [:]

	private(set) var info: [ID: Info] = [:]

	private(set) var identifiers: Set<ID> = .init()

	// MARK: - Initialization

	init(_ base: [Node<ItemContent>], transform: (ItemContent, Info) -> Model) {
		self.root = base.map(\.id)
		base.forEach { node in
			normalize(base: node, parent: nil)
		}
		base.forEach { node in
			makeItem(base: node, transform: transform)
		}
	}

	/// Initialize empty snapshot
	init() { }
}

// MARK: - Public interface
extension HierarchySnapshot {

	func rootItem(at index: Int) -> Model {
		let id = root[index]
		guard let model = cache[id] else {
			fatalError()
		}
		return model
	}

	func rootIdentifier(at index: Int) -> ID {
		return root[index]
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
		guard let id = storage[id]?[index], let model = cache[id] else {
			fatalError()
		}
		return model
	}

	func model(with id: ID) -> Model {
		return cache[unsafe: id]
	}
}

// MARK: - Helpers
private extension HierarchySnapshot {

	mutating func normalize(base: Node<ItemContent>, parent: ID?) {

		// Store in cache
		identifiers.insert(base.id)
		storage[base.id] = base.children.map(\.id)

		info[base.id] = Info(
			isDone: base.reduce(\.isDone),
			number: base.reduce(\.count),
			isLeaf: base.children.isEmpty,
			count: base.children.count
		)

		for child in base.children {
			normalize(base: child, parent: base.id)
		}
	}

	mutating func makeItem(base: Node<ItemContent>, transform: (ItemContent, Info) -> Model) {

		guard let info = self.info[base.id] else {
			fatalError()
		}

		// Store in cache
		cache[base.id] = transform(base.value, info)

		base.children.forEach { entity in
			makeItem(base: entity, transform: transform)
		}
	}
}

// MARK: - Nested data structs
extension HierarchySnapshot {

	struct Info {
		var isDone: Bool
		var number: Int
		var isLeaf: Bool
		var count: Int
	}
}
