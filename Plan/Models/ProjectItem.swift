//
//  ProjectItem.swift
//  Plan
//
//  Created by Anton Cherkasov on 10.06.2023.
//

import Foundation

struct ProjectItem {

	let uuid: UUID

	var name: String

	var creationDate: Date

	// MARK: - Initialization

	/// Basic initialization
	init(uuid: UUID = UUID(), name: String, creationDate: Date = Date()) {
		self.uuid = uuid
		self.name = name
		self.creationDate = creationDate
	}
}

// MARK: - Hashable
extension ProjectItem: Hashable { }
