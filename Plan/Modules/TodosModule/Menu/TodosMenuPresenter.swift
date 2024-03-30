//
//  TodosMenuPresenter.swift
//  Plan
//
//  Created by Anton Cherkasov on 06.02.2024.
//

import Foundation

final class TodosMenuPresenter {

	var provider: ListsDataProviderProtocol

	var localization: TodosMenuLocalization

	weak var menu: TodosContextMenuProtocol?

	weak var output: MenuDelegate?

	init(
		provider: ListsDataProviderProtocol,
		localization: TodosMenuLocalization
	) {
		self.provider = provider
		self.localization = localization
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
			.custom(.newTodo, content: .init(title: localization.newTodo, keyEquivalent: "n")),
			.separator,
			.custom(.focusOn, content: .init(title: localization.focusOnTask, keyEquivalent: "")),
			.custom(.moveToBacklog, content: .init(title: localization.moveToBacklog, keyEquivalent: "")),
			.separator,
			.custom(.markAsCompleted, content: .init(title: localization.markAsCompleted, keyEquivalent: "\r")),
			.custom(.markAsIncomplete, content: .init(title: localization.markAsIncomplete, keyEquivalent: "")),
			.separator,
			.menu(.setUrgency, content: .init(title: localization.priority, keyEquivalent: ""), items:
					[
						.custom(
							.priority(.low),
							content: .init(
								title: localization.priorityTitle(for: .low),
								keyEquivalent: "1"
							)
						),
						.custom(
							.priority(.medium),
							content: .init(
								title: localization.priorityTitle(for: .medium),
								keyEquivalent: "2"
							)
						),
						.custom(
							.priority(.high),
							content: .init(
								title: localization.priorityTitle(for: .high),
								keyEquivalent: "3"
							)
						),
					]
				 ),
			.separator,
			.menu(.moveToList, content: .init(title: localization.moveToList, keyEquivalent: ""), items: listItems),
			.separator,
			.custom(.delete, content: .init(title: localization.delete, keyEquivalent: "\u{0008}"))
		]

		menu?.display(items)
	}
}
