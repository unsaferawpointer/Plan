//
//  TodosInteractor.swift
//  Plan
//
//  Created by Anton Cherkasov on 29.01.2024.
//

import Foundation

protocol TodosInteractorProtocol: AnyObject {
	func fetchTodos() throws
	func perform(_ action: TodosAction) throws
	func perform(_ modification: TodoModification, forTodos ids: [UUID]) throws
}

final class TodosInteractor {

	private weak var presenter: TodosPresenterProtocol?

	private var provider: TodosDataProviderProtocol

	private var storage: DataStorageProtocol

	private var factory: TodosFactoryProtocol

	private var predicate: TodosPredicate

	// MARK: - Initialization

	init(
		presenter: TodosPresenterProtocol,
		provider: TodosDataProviderProtocol,
		storage: DataStorageProtocol,
		predicate: TodosPredicate,
		factory: TodosFactoryProtocol
	) {
		self.presenter = presenter
		self.provider = provider
		self.storage = storage
		self.predicate = predicate
		self.factory = factory
	}
}

// MARK: - TodosInteractorProtocol
extension TodosInteractor: TodosInteractorProtocol {

	func fetchTodos() throws {
		try provider.subscribe(self)
	}

	func perform(_ action: TodosAction) throws {
		switch action {
		case .insert(let texts):
			for text in texts {
				let todo = factory.createTodo(with: text, satisfyPredicate: predicate)
				try storage.insertTodo(todo, to: todo.list)
			}
		case .delete(let ids):
			try storage.deleteTodos(with: ids)
		}
		try storage.save()
	}

	func perform(_ modification: TodoModification, forTodos ids: [UUID]) throws {
		try storage.performModification(modification, forTodos: ids)
		try storage.save()
	}
}

// MARK: - TodosDataProviderDelegate
extension TodosInteractor: TodosDataProviderDelegate {

	func providerDidChangeContent(_ newContent: [Todo]) {
		presenter?.present(newContent)
	}
}
