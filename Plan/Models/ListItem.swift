//
//  ListItem.swift
//  Plan
//
//  Created by Anton Cherkasov on 10.06.2023.
//

import Foundation

struct ListItem {

	var uuid: UUID

	var name: String

	var isFavorite: Bool

	var creationDate: Date

	// MARK: - Initialization

	/// Basic initialization
	init(uuid: UUID = .init(), name: String, isFavorite: Bool, creationDate: Date = Date()) {
		self.uuid = uuid
		self.name = name
		self.isFavorite = isFavorite
		self.creationDate = creationDate
	}
}

// MARK: - Hashable
extension ListItem: Hashable { }
