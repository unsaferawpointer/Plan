//
//  TodosMenuItem+Extension.swift
//  Plan
//
//  Created by Anton Cherkasov on 31.03.2024.
//

import Foundation

extension MenuItem {

	static var newTodo: MenuItem {
		let title = String(localized: "new_todo")
		return .custom(.newTodo, content: .init(title: title, keyEquivalent: "n"))
	}

	static var focusOn: MenuItem {
		let title = String(localized: "focus_on_the_task")
		return .custom(.focusOn, content: .init(title: title, keyEquivalent: ""))
	}

	static var moveToBacklog: MenuItem {
		let title = String(localized: "move_to_backlog")
		return .custom(.moveToBacklog, content: .init(title: title, keyEquivalent: ""))
	}

	static var markAsCompleted: MenuItem {
		let title = String(localized: "mark_as_completed")
		return .custom(.markAsCompleted, content: .init(title: title, keyEquivalent: "\r"))
	}

	static var markAsIncomplete: MenuItem {
		let title = String(localized: "mark_as_incomplete")
		return .custom(.markAsIncomplete, content: .init(title: title, keyEquivalent: ""))
	}

	static var lowPriority: MenuItem {
		let title = String(localized: "low_priority")
		return .custom(.priority(.low), content: .init(title: title, keyEquivalent: "1"))
	}

	static var mediumPriority: MenuItem {
		let title = String(localized: "medium_priority")
		return .custom(.priority(.medium), content: .init(title: title, keyEquivalent: "2"))
	}

	static var highPriority: MenuItem {
		let title = String(localized: "high_priority")
		return .custom(.priority(.high), content: .init(title: title, keyEquivalent: "3"))
	}

	static var setPriority: MenuItem {
		return .menu(
			.setPriority,
			content: .init(
				title: String(localized: "priority"),
				keyEquivalent: ""
			),
			items: [.lowPriority, .mediumPriority, .highPriority]
		)
	}

	static func moveToList(with lists: [MenuItem]) -> MenuItem {
		let title = String(localized: "move_to_list")
		return .menu(.moveToList, content: .init(title: title, keyEquivalent: ""), items: lists)
	}
}

private extension String {

	init(localized: String.LocalizationValue) {
		self.init(localized: localized, table: "TodosMenuLocalizable")
	}
}
