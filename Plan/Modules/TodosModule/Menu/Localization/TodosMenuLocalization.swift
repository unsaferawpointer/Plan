//
//  TodosMenuLocalization.swift
//  Plan
//
//  Created by Anton Cherkasov on 30.03.2024.
//

import Foundation

protocol TodosMenuLocalizationProtocol {

	var newTodo: String { get }

	var focusOnTask: String { get }

	var moveToBacklog: String { get }

	var markAsCompleted: String { get }

	var markAsIncomplete: String { get }

	var priority: String { get }

	var moveToList: String { get }

	var delete: String { get }

	func priorityTitle(for priority: Priority) -> String

}

final class TodosMenuLocalization { }

// MARK: - TodosMenuLocalizationProtocol
extension TodosMenuLocalization: TodosMenuLocalizationProtocol {

	var newTodo: String {
		return String(localized: "new_todo")
	}
	
	var focusOnTask: String {
		return String(localized: "focus_on_the_task")
	}
	
	var moveToBacklog: String {
		return String(localized: "move_to_backlog")
	}
	
	var markAsCompleted: String {
		return String(localized: "mark_as_completed")
	}
	
	var markAsIncomplete: String {
		return String(localized: "mark_as_incomplete")
	}
	
	var priority: String {
		return String(localized: "priority")
	}
	
	var moveToList: String {
		return String(localized: "move_to_list")
	}
	
	var delete: String {
		return String(localized: "delete")
	}

	func priorityTitle(for priority: Priority) -> String {
		switch priority {
		case .low:
			String(localized: "low_priority")
		case .medium:
			String(localized: "medium_priority")
		case .high:
			String(localized: "high_priority")
		}
	}
}

private extension String {

	init(localized: String.LocalizationValue) {
		self.init(localized: localized, table: "TodosMenuLocalizable")
	}
}
