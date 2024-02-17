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
	var isFavorite: Bool

	var status: TodoStatus

	var list: UUID?
	var listName: String?

	// MARK: - Initialization

	init(
		uuid: UUID = UUID(),
		creationDate: Date = Date(),
		text: String,
		isFavorite: Bool = false,
		status: TodoStatus = .incomplete,
		list: UUID? = nil,
		listName: String? = nil
	) {
		self.uuid = uuid
		self.creationDate = creationDate
		self.text = text
		self.isFavorite = isFavorite
		self.status = status
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

enum TodoStatus {
	case incomplete
	case inProgress(startDate: Date)
	case isDone(startDate: Date, completionDate: Date)
}

// MARK: - Hashable
extension TodoStatus: Hashable { }

//extension TodoStatus {
//
//	func next() -> TodoStatus? {
//		switch self {
//		case .incomplete:
//			return .inProgress(startDate: Date())
//		case .inProgress(let startDate):
//			return .isDone(startDate: startDate, completionDate: Date())
//		case .isDone(let startDate, let completionDate):
//			<#code#>
//		}
//	}
//}

extension TodoStatus {

	var startDate: Date? {
		switch self {
		case .incomplete:
			return nil
		case .inProgress(let startDate):
			return startDate
		case .isDone(let startDate, _):
			return startDate
		}
	}

	var completionDate: Date? {
		switch self {
		case .isDone(_ , let completionDate):
			return completionDate
		default:
			return nil
		}
	}

	var isDone: Bool {
		switch self {
		case .incomplete:
			return false
		case .inProgress:
			return false
		case .isDone:
			return true
		}
	}
}
