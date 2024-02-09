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

	var project: UUID?
	var projectName: String?

	// MARK: - Initialization

	init(
		uuid: UUID = UUID(),
		creationDate: Date = Date(),
		text: String,
		inFocus: Bool = false,
		isFavorite: Bool = false,
		isDone: Bool = false,
		project: UUID? = nil,
		projectName: String? = nil
	) {
		self.uuid = uuid
		self.creationDate = creationDate
		self.text = text
		self.inFocus = inFocus
		self.isFavorite = isFavorite
		self.isDone = isDone
		self.projectName = projectName
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
