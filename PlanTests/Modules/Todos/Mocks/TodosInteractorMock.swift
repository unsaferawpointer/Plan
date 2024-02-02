//
//  TodosInteractorMock.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 30.01.2024.
//

import Foundation
@testable import Plan

final class TodosInteractorMock {

	private (set) var invocations: [Action] = []
}

// MARK: - TodosInteractorProtocol
extension TodosInteractorMock: TodosInteractorProtocol {

	func deleteTodo(withId id: UUID) throws {
		let action: Action = .deleteTodo(withId: id)
		invocations.append(action)
	}

	func setText(_ text: String, forTodo id: UUID) throws {
		let action: Action = .setText(text: text, forTodo: id)
		invocations.append(action)
	}

	func setStatus(_ newValue: Bool, forTodos ids: [UUID]) throws {
		let action: Action = .setStatus(newValue: newValue, forTodos: ids)
		invocations.append(action)
	}

	func fetchTodos() throws {
		let action: Action = .fetchTodos
		invocations.append(action)
	}

	func createTodo(withText text: String) throws {
		let action: Action = .createTodo(withText: text)
		invocations.append(action)
	}
}

// MARK: - Nested data structs
extension TodosInteractorMock {

	enum Action {
		case fetchTodos
		case createTodo(withText: String)
		case setText(text: String, forTodo: UUID)
		case setStatus(newValue: Bool, forTodos: [UUID])
		case deleteTodo(withId: UUID)
	}
}

