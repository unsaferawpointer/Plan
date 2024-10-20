//
//  HierarchyModel.swift
//  Hierarchy
//
//  Created by Anton Cherkasov on 29.09.2023.
//

import AppKit

struct HierarchyModel {

	var uuid: UUID

	var content: ItemCellModel

	var createdAt: TextCell.Model

	var completedAt: TextCell.Model

	var value: TextCell.Model

	var priority: IconCell.Model

	var menu: MenuItem

	// MARK: - Initialization

	init(
		uuid: UUID = UUID(),
		content: ItemCellModel,
		createdAt: TextCell.Model,
		completedAt: TextCell.Model,
		value: TextCell.Model,
		priority: IconCell.Model,
		menu: MenuItem
	) {
		self.uuid = uuid
		self.content = content
		self.createdAt = createdAt
		self.completedAt = completedAt
		self.value = value
		self.priority = priority
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
