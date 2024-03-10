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
	var priority: Priority

	var list: UUID?
	var listName: String?

	// MARK: - Initialization

	init(
		uuid: UUID = UUID(),
		creationDate: Date = Date(),
		text: String,
		status: TodoStatus = .default,
		priority: Priority = .low,
		list: UUID? = nil,
		listName: String? = nil
	) {
		self.uuid = uuid
		self.creationDate = creationDate
		self.text = text
		self.status = status
		self.priority = priority
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

// MARK: - Computed properties
extension Todo {

	var isDone: Bool {
		return status.isDone
	}
}

enum TodoStatus: Int16 {
	case `default` = 0
	case inFocus
	case done
}

enum Priority: Int16 {
	case low = 0
	case medium
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
