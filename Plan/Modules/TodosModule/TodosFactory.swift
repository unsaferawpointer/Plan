//
//  TodosFactory.swift
//  Plan
//
//  Created by Anton Cherkasov on 03.02.2024.
//

import Foundation

protocol TodosFactoryProtocol {
	func createTodo(with text: String) -> Todo
}

final class TodosFactory {

	var configuration: TodosConfiguration

	// MARK: - Initialization

	init(configuration: TodosConfiguration) {
		self.configuration = configuration
	}
}

// MARK: - TodosFactoryProtocol
extension TodosFactory: TodosFactoryProtocol {

	func createTodo(with text: String) -> Todo {

		var todo = Todo(text: text, listName: nil)

		switch configuration {
		case .inFocus:
			todo.inFocus = true
		case .backlog:
			todo.isDone = false
			todo.inFocus = false
		case .favorites:
			todo.isFavorite = true
			todo.isDone = false
		case .list(let id):
			todo.list = id
		case .archieve:
			todo.isDone = true
		}

		return todo
	}
}
