//
//  HierarchyContent.swift
//  Hierarchy
//
//  Created by Anton Cherkasov on 27.09.2023.
//

import Foundation

final class HierarchyContent {

	private (set) var uuid: UUID

	private (set) var hierarchy: Root<ItemContent>

	// MARK: - Initialization

	init(uuid: UUID, hierarchy: [Node<ItemContent>] = []) {
		self.uuid = uuid
		self.hierarchy = Root(hierarchy: hierarchy)
	}
}

// MARK: - Codable
extension HierarchyContent: Codable {

	enum CodingKeys: CodingKey {
		case uuid
		case hierarchy
	}

	convenience init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let uuid = try container.decode(UUID.self, forKey: .uuid)
		let hierarchy = try container.decodeIfPresent([Node<ItemContent>].self, forKey: .hierarchy) ?? []
		self.init(uuid: uuid, hierarchy: hierarchy)
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(uuid, forKey: .uuid)
		try container.encode(hierarchy.nodes, forKey: .hierarchy)
	}
}

// MARK: - Equatable
extension HierarchyContent: Equatable {

	static func == (lhs: HierarchyContent, rhs: HierarchyContent) -> Bool {
		return lhs.uuid == rhs.uuid && lhs.hierarchy == rhs.hierarchy
	}
}

// MARK: - Configure properties
extension HierarchyContent {

	func setText(_ value: String, for id: UUID) {
		hierarchy.setProperty(\.text, to: value, for: [id], downstream: false)
	}

	func setStatus(_ value: Bool, for ids: [UUID]) {
		hierarchy.setProperty(\.isDone, to: value, for: ids, downstream: true)
	}

	func setFavoriteFlag(_ flag: Bool, for ids: [UUID]) {
		hierarchy.setProperty(\.isFavorite, to: flag, for: ids, downstream: false)
	}

	func setEstimation(_ value: Int, for ids: [UUID]) {
		hierarchy.setProperty(\.count, to: value, for: ids, downstream: false)
	}

	func setIcon(_ value: String?, for ids: [UUID]) {
		hierarchy.setProperty(\.iconName, to: value, for: ids, downstream: false)
	}

}

extension HierarchyContent {

	func insertItems(with contents: [ItemContent], to destination: HierarchyDestination<UUID>) {
		hierarchy.insertItems(with: contents, to: destination)
	}

	func insertItems<T: TreeNode>(from nodes: [T], to destination: HierarchyDestination<UUID>) where T.Value == ItemContent {
		hierarchy.insertItems(from: nodes, to: destination)
	}

	func deleteItems(_ ids: [UUID]) {
		hierarchy.deleteItems(ids)
	}

	func moveItems(with ids: [UUID], to destination: HierarchyDestination<UUID>) {
		hierarchy.moveItems(with: ids, to: destination)
	}

	func validateMoving(_ ids: [UUID], to destination: HierarchyDestination<UUID>) -> Bool {
		return hierarchy.validateMoving(ids, to: destination)
	}
}

// MARK: Values by-default
extension HierarchyContent {

	static var empty: HierarchyContent {
		return HierarchyContent(uuid: .init())
	}
}
