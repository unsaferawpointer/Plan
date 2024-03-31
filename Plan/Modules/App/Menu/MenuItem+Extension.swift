//
//  MenuItem+Extension.swift
//  Plan
//
//  Created by Anton Cherkasov on 31.03.2024.
//

import Foundation

// MARK: Main menu items
extension MenuItem {

	static var main: MenuItem {
		return .menu(
			.main,
			content: .init(title: "", keyEquivalent: ""),
			items: [.about, .separator, .quit]
		)
	}

	static var file: MenuItem {
		return .menu(
			.file,
			content: .init(
				title: String(localized: "file"),
				keyEquivalent: ""
			),
			items: [.newTodo, .newList]
		)
	}

	static var edit: MenuItem {
		return .menu(
			.editor,
			content: .init(
				title: String(localized: "edit"),
				keyEquivalent: ""
			),
			items:
				[
					.focusOn,
					.moveToBacklog,
					.separator,
					.markAsCompleted,
					.markAsIncomplete,
					.separator,
					.setPriority,
					.separator,
					.delete
				]
		)
	}
}

extension MenuItem {

	static var about: MenuItem {
		let title = String(localized: "about")
		return .custom(.about, content: .init(title: title, keyEquivalent: ""))
	}

	static var quit: MenuItem {
		let title = String(localized: "quit")
		return .custom(.quit, content: .init(title: title, keyEquivalent: "q"))
	}

	static var delete: MenuItem {
		let title = String(localized: "delete")
		return .custom(.delete, content: .init(title: title, keyEquivalent: "\u{0008}"))
	}
}

private extension String {

	init(localized: String.LocalizationValue) {
		self.init(localized: localized, table: "MenuLocalizable")
	}
}
