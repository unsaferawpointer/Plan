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
	var inFocus: Bool
	var isFavorite: Bool

	var isDone: Bool

	// MARK: - Initialization

	init(
		uuid: UUID,
		creationDate: Date,
		text: String,
		inFocus: Bool,
		isFavorite: Bool,
		isDone: Bool
	) {
		self.uuid = uuid
		self.creationDate = creationDate
		self.text = text
		self.inFocus = inFocus
		self.isFavorite = isFavorite
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
