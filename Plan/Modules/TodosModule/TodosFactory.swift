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
		case .inProgress:
			todo.status = .inProgress(startDate: Date())
		case .backlog:
			todo.status = .incomplete
		case .favorites:
			todo.isFavorite = true
		case .list(let id):
			todo.list = id
		case .archieve:
			let date = Date()
			todo.status = .isDone(startDate: date, completionDate: date)
		}

		return todo
	}
}
