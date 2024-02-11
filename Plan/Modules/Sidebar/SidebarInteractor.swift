//
//  SidebarInteractor.swift
//  Plan
//
//  Created by Anton Cherkasov on 10.02.2024.
//

import Foundation

protocol SidebarInteractorProtocol {
	func fetchLists() throws
	func perform(_ modification: ListModification, forLists ids: [UUID]) throws
}

final class SidebarInteractor {

	weak var presenter: SidebarPresenterProtocol?

	private var provider: ListsDataProviderProtocol

	private var storage: PersistentContainerProtocol

	// MARK: - Initialization

	init(
		provider: ListsDataProviderProtocol,
		storage: PersistentContainerProtocol
	) {
		self.provider = provider
		self.storage = storage
	}
}

// MARK: - SidebarInteractorProtocol
extension SidebarInteractor: SidebarInteractorProtocol {

	func fetchLists() throws {
		try provider.subscribe(self)
	}

	func perform(_ modification: ListModification, forLists ids: [UUID]) throws {
		try storage.performModification(modification, forLists: ids)
		try storage.save()
	}
}

// MARK: - ListsDataProviderDelegate
extension SidebarInteractor: ListsDataProviderDelegate {

	func providerDidChangeContent(_ newContent: [List]) {
		presenter?.present(newContent)
	}
}
