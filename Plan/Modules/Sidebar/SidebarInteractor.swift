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
	func perform(_ action: SidebarAction) throws
}

final class SidebarInteractor {

	weak var presenter: SidebarPresenterProtocol?

	private var provider: ListsDataProviderProtocol

	private var storage: DataStorageProtocol

	// MARK: - Initialization

	init(
		provider: ListsDataProviderProtocol,
		storage: DataStorageProtocol
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

	func perform(_ action: SidebarAction) throws {
		switch action {
		case .insert(let id, let title):
			let list = List(uuid: id, title: title, count: 0)
			try storage.insertList(list)
		case .delete(let ids):
			try storage.deleteLists(with: ids)
		}
		try storage.save()
	}
}

// MARK: - ListsDataProviderDelegate
extension SidebarInteractor: ListsDataProviderDelegate {

	func providerDidChangeContent(_ newContent: [List]) {
		presenter?.present(newContent)
	}
}
