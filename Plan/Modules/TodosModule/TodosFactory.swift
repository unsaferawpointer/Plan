//
//  TodosFactory.swift
//  Plan
//
//  Created by Anton Cherkasov on 03.02.2024.
//

import Foundation

protocol TodosFactoryProtocol {
	func createTodo(with id: UUID, text: String, satisfyPredicate predicate: TodosPredicate) -> Todo
}

final class TodosFactory { }

// MARK: - TodosFactoryProtocol
extension TodosFactory: TodosFactoryProtocol {

	func createTodo(with id: UUID, text: String, satisfyPredicate predicate: TodosPredicate) -> Todo {

		var todo = Todo(uuid: id, text: text, listName: nil)

		switch predicate {
		case .list(let id):
			todo.list = id
		case .status(let value):
			todo.status = value
		}

		return todo
	}
}
