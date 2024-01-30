//
//  Todo.swift
//  Plan
//
//  Created by Anton Cherkasov on 20.01.2024.
//

import Foundation

struct Todo {

	var uuid: UUID
	var creationDate: Date
	var text: String
	var options: Int64

	var isDone: Bool

	// MARK: - Initialization

	init(
		uuid: UUID,
		creationDate: Date,
		text: String,
		options: Int64,
		isDone: Bool
	) {
		self.uuid = uuid
		self.creationDate = creationDate
		self.text = text
		self.options = options
		self.isDone = isDone
	}
}

// MARK: - Hashable
extension Todo: Hashable { }

// MARK: - Identifiable
extension Todo: Identifiable {

	var id: UUID {
		return uuid
	}
}
