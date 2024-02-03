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
	func setText(_ text: String, forTodo id: UUID) throws
	func setStatus(_ newValue: Bool, forTodos ids: [UUID]) throws
	func deleteTodo(withId id: UUID) throws
}

final class TodosInteractor {

	private weak var presenter: TodosPresenterProtocol?

	private var provider: TodosDataProviderProtocol

	private var storage: PersistentContainerProtocol

	private var factory: TodosFactoryProtocol

	// MARK: - Initialization

	init(
		presenter: TodosPresenterProtocol,
		provider: TodosDataProviderProtocol,
		storage: PersistentContainerProtocol,
		factory: TodosFactoryProtocol
	) {
		self.presenter = presenter
		self.provider = provider
		self.storage = storage
		self.factory = factory
	}
}

// MARK: - TodosInteractorProtocol
extension TodosInteractor: TodosInteractorProtocol {

	func fetchTodos() throws {
		try provider.subscribe(self)
	}

	func createTodo(withText text: String) throws {

		let todo = factory.createTodo(with: text)

		try storage.insertTodo(todo, to: todo.project)
		try storage.save()
	}

	func setText(_ text: String, forTodo id: UUID) throws {
		try storage.setTodo(text: text, with: id)
		try storage.save()
	}

	func setStatus(_ newValue: Bool, forTodos ids: [UUID]) throws {
		try storage.setStatus(newValue, forTodos: ids)
		try storage.save()
	}

	func deleteTodo(withId id: UUID) throws {
		try storage.deleteTodos(with: [id])
		try storage.save()
	}
}

// MARK: - TodosDataProviderDelegate
extension TodosInteractor: TodosDataProviderDelegate {

	func providerDidChangeContent(_ newContent: [Todo]) {
		presenter?.present(newContent)
	}
}
