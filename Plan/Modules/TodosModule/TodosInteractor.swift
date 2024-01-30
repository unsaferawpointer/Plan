//
//  TodosInteractor.swift
//  Plan
//
//  Created by Anton Cherkasov on 29.01.2024.
//

import Foundation

protocol TodosInteractorProtocol: AnyObject {
	func fetchTodos() throws
}

final class TodosInteractor {

	private weak var presenter: TodosPresenterProtocol?

	private var provider: TodosDataProviderProtocol

	private var storage: PersistentContainerProtocol

	// MARK: - Initialization

	init(
		presenter: TodosPresenterProtocol? = nil,
		provider: TodosDataProviderProtocol,
		storage: PersistentContainerProtocol
	) {
		self.presenter = presenter
		self.provider = provider
		self.storage = storage
	}
}

// MARK: - TodosInteractorProtocol
extension TodosInteractor: TodosInteractorProtocol {

	func fetchTodos() throws {
		try provider.subscribe(self)
	}
}

// MARK: - TodosDataProviderDelegate
extension TodosInteractor: TodosDataProviderDelegate {

	func providerDidChangeContent(_ newContent: [Todo]) {
		presenter?.present(newContent)
	}
}
