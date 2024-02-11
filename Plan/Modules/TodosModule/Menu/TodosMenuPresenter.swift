//
//  TodosMenuPresenter.swift
//  Plan
//
//  Created by Anton Cherkasov on 06.02.2024.
//

import Foundation

final class TodosMenuPresenter {

	var provider: ListsDataProviderProtocol

	weak var menu: TodosContextMenuProtocol?

	weak var output: TodosMenuDelegate?

	init(provider: ListsDataProviderProtocol) {
		self.provider = provider
	}
}

// MARK: - TodosContextMenuOutput
extension TodosMenuPresenter: TodosContextMenuOutput {

	func menuWillOpen() {
		do {
			try provider.subscribe(self)
		} catch {
			// TODO: - Handle action
		}
	}

	func menuDidClose() {
		// TODO: - Handle action
	}

	func itemHasBeenClicked(_ item: MenuItem.Identifier) {
		output?.menuItemHasBeenClicked(item)
	}

	func validateItem(_ item: MenuItem.Identifier) -> Bool {
		return output?.validateMenuItem(item) ?? false
	}
}

// MARK: - ListsDataProviderDelegate
extension TodosMenuPresenter: ListsDataProviderDelegate {

	func providerDidChangeContent(_ newContent: [List]) {

		let listItems: [MenuItem] = newContent.map { list in
				.custom(.uuid(list.uuid), content: .init(title: list.title, keyEquivalent: ""))
		}

		let items: [MenuItem] =
		[
			.custom(.newTodo, content: .init(title: "New todo", keyEquivalent: "n")),
			.separator,
			.custom(.markAsCompleted, content: .init(title: "Mark as Completed", keyEquivalent: "\r")),
			.custom(.markAsIncomplete, content: .init(title: "Mark as Incomplete", keyEquivalent: "")),
			.separator,
			.custom(.bookmark, content: .init(title: "Bookmark", keyEquivalent: "b")),
			.custom(.unbookmark, content: .init(title: "Unbookmark", keyEquivalent: "")),
			.separator,
			.menu(.moveToList, content: .init(title: "Move to list", keyEquivalent: ""), items: listItems),
			.separator,
			.custom(.delete, content: .init(title: "Delete", keyEquivalent: "\u{0008}"))
		]

		menu?.display(items)
	}
}
