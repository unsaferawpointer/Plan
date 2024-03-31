//
//  TodosLocalization.swift
//  Plan
//
//  Created by Anton Cherkasov on 29.03.2024.
//

import Foundation

protocol TodosLocalizationProtocol {

	var headerLowPriority: String { get }

	var headerMediumPriority: String { get }

	var headerHighPriority: String { get }

	var headerCompleted: String { get }

	var headerInFocus: String { get }

	var headerIncomplete: String { get }

	func infoSubtitle(count: Int) -> String

	func infoSubtitleCompletedTodos(count: Int) -> String

	var infoSubtitleForEmptyState: String { get }

	var infoSubtitleAllTasksAreCompleted: String { get }

	var placeholderTitle: String { get }

	var placeholderSubtitle: String { get }

	var newTodoTitlePlaceholder: String { get }
}

final class TodosLocalization { }

// MARK: - TodosLocalizationProtocol
extension TodosLocalization: TodosLocalizationProtocol {

	var headerLowPriority: String {
		return String(localized: "header_low_priority")
	}
	
	var headerMediumPriority: String {
		return String(localized: "header_medium_priority")
	}
	
	var headerHighPriority: String {
		return String(localized: "header_high_priority")
	}

	var headerCompleted: String {
		return String(localized: "header_completed")
	}

	var headerInFocus: String {
		return String(localized: "header_in_focus")
	}

	var headerIncomplete: String {
		return String(localized: "header_incomplete")
	}

	func infoSubtitle(count: Int) -> String {
		return String(localized: "\(count) incomplete todo")
	}

	func infoSubtitleCompletedTodos(count: Int) -> String {
		return String(localized: "\(count) completed todos")
	}

	var infoSubtitleForEmptyState: String {
		return String(localized: "info_subtitle_for_empty_state")
	}

	var infoSubtitleAllTasksAreCompleted: String {
		return String(localized: "info_subtitle_for_completed_todos")
	}

	var placeholderTitle: String {
		return String(localized: "placeholder_title")
	}

	var placeholderSubtitle: String {
		return String(localized: "placeholder_subtitle")
	}

	var newTodoTitlePlaceholder: String {
		return String(localized: "new_todo_title_placeholder")
	}
}

private extension String {

	init(localized: String.LocalizationValue) {
		self.init(localized: localized, table: "TodosLocalizable")
	}
}
