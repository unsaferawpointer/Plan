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

	weak var output: TodosMenuOutput?

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

	func itemHasBeenClicked(_ item: TodosMenuItemIdentifier) {
		output?.menuItemHasBeenClicked(item)
	}
}

// MARK: - ProjectsDataProviderDelegate
extension TodosMenuPresenter: ProjectsDataProviderDelegate {

	func providerDidChangeContent(_ newContent: [Project]) {
		menu?.display(newContent)
	}
}
