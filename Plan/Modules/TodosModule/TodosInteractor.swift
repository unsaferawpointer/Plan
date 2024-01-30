//
//  TodosInteractor.swift
//  Plan
//
//  Created by Anton Cherkasov on 29.01.2024.
//

import Foundation

protocol TodosInteractorProtocol: AnyObject {
	func fetchTodos() throws
	func createTodo(withText text: String) throws
}

final class TodosInteractor {

	private weak var presenter: TodosPresenterProtocol?

	private var provider: TodosDataProviderProtocol

	private var storage: PersistentContainerProtocol

	// MARK: - Initialization

	init(
		presenter: TodosPresenterProtocol,
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

	func createTodo(withText text: String) throws {
		let todo = Todo(
			uuid: .init(),
			creationDate: Date(),
			text: text,
			options: 0,
			isDone: false
		)
		try storage.insertTodo(todo, to: nil)
		try storage.save()
	}
}

// MARK: - TodosDataProviderDelegate
extension TodosInteractor: TodosDataProviderDelegate {

	func providerDidChangeContent(_ newContent: [Todo]) {
		presenter?.present(newContent)
	}
}
