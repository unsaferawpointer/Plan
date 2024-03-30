//
//  TodosToolbarLocalization.swift
//  Plan
//
//  Created by Anton Cherkasov on 31.03.2024.
//

import Foundation

protocol TodosToolbarLocalizationProtocol {

	var newTodo: String { get }

	var groupTodos: String { get }

	func title(for grouping: TodosGrouping) -> String
}

final class TodosToolbarLocalization { }

// MARK: - TodosToolbarLocalizationProtocol
extension TodosToolbarLocalization: TodosToolbarLocalizationProtocol {

	var newTodo: String {
		String(localized: "new_todo")
	}

	var groupTodos: String {
		String(localized: "group_todos")
	}

	func title(for grouping: TodosGrouping) -> String {
		switch grouping {
		case .none:
			String(localized: "grouping_none")
		case .list:
			String(localized: "grouping_list")
		case .priority:
			String(localized: "grouping_priority")
		case .status:
			String(localized: "grouping_status")
		}
	}
}

private extension String {

	init(localized: String.LocalizationValue) {
		self.init(localized: localized, table: "TodosToolbarLocalizable")
	}
}
