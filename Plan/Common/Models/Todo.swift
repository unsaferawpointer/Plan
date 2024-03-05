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

	var status: TodoStatus
	var urgency: Urgency

	var list: UUID?
	var listName: String?

	// MARK: - Initialization

	init(
		uuid: UUID = UUID(),
		creationDate: Date = Date(),
		text: String,
		status: TodoStatus = .default,
		urgency: Urgency = .none,
		list: UUID? = nil,
		listName: String? = nil
	) {
		self.uuid = uuid
		self.creationDate = creationDate
		self.text = text
		self.status = status
		self.urgency = urgency
		self.list = list
		self.listName = listName
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

enum TodoStatus: Int16 {
	case `default` = 0
	case inFocus
	case done
}

enum Urgency: Int16 {
	case none = 0
	case middle
	case high
}

// MARK: - Hashable
extension TodoStatus: Hashable { }

// MARK: - Computed properties
extension TodoStatus {

	var isDone: Bool {
		switch self {
		case .default:
			return false
		case .inFocus:
			return false
		case .done:
			return true
		}
	}
}
