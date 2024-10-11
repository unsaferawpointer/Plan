//
//  PlanContent.swift
//  Hierarchy
//
//  Created by Anton Cherkasov on 27.09.2023.
//

import Foundation

final class PlanContent {

	private(set) var uuid: UUID

	private(set) var hierarchy: Root<ItemContent>

	// MARK: - Initialization

	init(uuid: UUID, hierarchy: [Node<ItemContent>] = []) {
		self.uuid = uuid
		self.hierarchy = Root(hierarchy: hierarchy)
	}
}

// MARK: - Codable
extension PlanContent: Codable {

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
extension PlanContent: Equatable {

	static func == (lhs: PlanContent, rhs: PlanContent) -> Bool {
		return lhs.uuid == rhs.uuid && lhs.hierarchy == rhs.hierarchy
	}
}

// MARK: - Configure properties
extension PlanContent {

	func perform(_ modification: some Modification<ItemContent>, for ids: [UUID], downstream: Bool = false) {
		hierarchy.setProperty(
			modification.keyPath,
			to: modification.value,
			for: ids,
			downstream: downstream
		)
	}

//	func setText(_ value: String, for id: UUID) {
//		hierarchy.setProperty(\.text, to: value, for: [id], downstream: false)
//	}
//
//	func setStatus(_ value: Bool, for ids: [UUID]) {
//		hierarchy.setProperty(\.isDone, to: value, for: ids, downstream: true)
//	}
//
//	func setFavoriteFlag(_ flag: Bool, for ids: [UUID]) {
//		hierarchy.setProperty(\.isFavorite, to: flag, for: ids, downstream: false)
//	}
//
//	func setEstimation(_ value: Int, for ids: [UUID]) {
//		hierarchy.setProperty(\.count, to: value, for: ids, downstream: false)
//	}
//
//	func setIcon(_ value: IconName?, for ids: [UUID]) {
//		hierarchy.setProperty(\.iconName, to: value, for: ids, downstream: false)
//	}

}

extension PlanContent {

	func insertItems(with contents: [ItemContent], to destination: HierarchyDestination<UUID>) {
		hierarchy.insertItems(with: contents, to: destination)
	}

	func insertItems(from nodes: [any TreeNode<ItemContent>], to destination: HierarchyDestination<UUID>) {
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
extension PlanContent {

	static var empty: PlanContent {
		return PlanContent(uuid: .init())
	}
}
