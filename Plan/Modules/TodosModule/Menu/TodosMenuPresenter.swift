//
//  TodosMenuPresenter.swift
//  Plan
//
//  Created by Anton Cherkasov on 06.02.2024.
//

import Foundation

final class TodosMenuPresenter {

	var provider: ProjectsDataProviderProtocol

	weak var menu: TodosContextMenuProtocol?

	weak var output: TodosMenuDelegate?

	init(provider: ProjectsDataProviderProtocol) {
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

// MARK: - ProjectsDataProviderDelegate
extension TodosMenuPresenter: ProjectsDataProviderDelegate {

	func providerDidChangeContent(_ newContent: [Project]) {

		let projectItems: [MenuItem] = newContent.map { project in
				.custom(.uuid(project.uuid), content: .init(title: project.title, keyEquivalent: ""))
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
			.menu(.moveToProject, content: .init(title: "Move to project", keyEquivalent: ""), items: projectItems),
			.separator,
			.custom(.delete, content: .init(title: "Delete", keyEquivalent: "\u{0008}"))
		]

		menu?.display(items)
	}
}
