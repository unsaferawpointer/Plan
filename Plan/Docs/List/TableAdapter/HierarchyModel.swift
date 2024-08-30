//
//  HierarchyModel.swift
//  Hierarchy
//
//  Created by Anton Cherkasov on 29.09.2023.
//

import AppKit

struct HierarchyModel {

	var uuid: UUID

	var content: PlanItemModel

	var createdAt: String

	var completedAt: String

	var badge: String?

	var menu: MenuItem

	// MARK: - Initialization

	init(
		uuid: UUID = UUID(),
		content: PlanItemModel,
		createdAt: String,
		completedAt: String,
		badge: String?,
		menu: MenuItem
	) {
		self.uuid = uuid
		self.content = content
		self.createdAt = createdAt
		self.completedAt = completedAt
		self.badge = badge
		self.menu = menu
	}
}

// MARK: - Identifiable
extension HierarchyModel: Identifiable {

	var id: UUID {
		return uuid
	}
}

// MARK: - Hashable
extension HierarchyModel: Hashable {

	static func == (lhs: HierarchyModel, rhs: HierarchyModel) -> Bool {
		return lhs.uuid == rhs.uuid
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(uuid)
	}
}
