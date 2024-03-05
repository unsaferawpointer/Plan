//
//  TodosFactory.swift
//  Plan
//
//  Created by Anton Cherkasov on 03.02.2024.
//

import Foundation

protocol TodosFactoryProtocol {
	func createTodo(with text: String, satisfyPredicate predicate: TodosPredicate) -> Todo
}

final class TodosFactory { }

// MARK: - TodosFactoryProtocol
extension TodosFactory: TodosFactoryProtocol {

	func createTodo(with text: String, satisfyPredicate predicate: TodosPredicate) -> Todo {

		var todo = Todo(text: text, listName: nil)

		switch predicate {
		case .inFocus:
			todo.status = .inFocus
		case .backlog:
			todo.status = .default
		case .list(let id):
			todo.list = id
		case .isDone:
			let date = Date()
			todo.status = .done
		}

		return todo
	}
}
