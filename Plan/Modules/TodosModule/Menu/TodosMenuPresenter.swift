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

	weak var output: MenuDelegate?

	init(
		provider: ListsDataProviderProtocol
	) {
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
				.custom(.list(list.uuid), content: .init(title: list.title, keyEquivalent: ""))
		}

		let items: [MenuItem] =
		[
			.newTodo,
			.separator,
			.focusOn,
			.moveToBacklog,
			.separator,
			.markAsCompleted,
			.markAsIncomplete,
			.separator,
			.setPriority,
			.separator,
			.moveToList(with: listItems),
			.separator,
			.delete
		]

		menu?.display(items)
	}
}
