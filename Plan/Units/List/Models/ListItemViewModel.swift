//
//  ListItemViewModel.swift
//  Plan
//
//  Created by Anton Cherkasov on 22.10.2024.
//

import Foundation

struct ListItemViewModel {

	var uuid: UUID

	var status: CheckboxCell.Model

	var description: TextCell.Model

	var createdAt: TextCell.Model

	var completedAt: TextCell.Model

	var value: TextCell.Model

	var priority: IconCell.Model

	var menu: MenuItem

	// MARK: - Initialization

	init(
		uuid: UUID = UUID(),
		status: CheckboxCell.Model,
		description: TextCell.Model,
		createdAt: TextCell.Model,
		completedAt: TextCell.Model,
		value: TextCell.Model,
		priority: IconCell.Model,
		menu: MenuItem
	) {
		self.uuid = uuid
		self.status = status
		self.description = description
		self.createdAt = createdAt
		self.completedAt = completedAt
		self.value = value
		self.priority = priority
		self.menu = menu
	}
}

// MARK: - Identifiable
extension ListItemViewModel: Identifiable {

	var id: UUID {
		return uuid
	}
}

// MARK: - Hashable
extension ListItemViewModel: Hashable {

	static func == (lhs: ListItemViewModel, rhs: ListItemViewModel) -> Bool {
		return lhs.uuid == rhs.uuid
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(uuid)
	}
}
