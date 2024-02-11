//
//  PersistentContainerMock.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 28.01.2024.
//

import Foundation
@testable import Plan

final class PersistentContainerMock {
	private (set) var invocations: [Action] = []
}

// MARK: - PersistentContainerProtocol
extension PersistentContainerMock: PersistentContainerProtocol {

	func insertTodo(_ todo: Todo, to list: UUID?) throws {
		let action: Action = .insertTodo(todo: todo, toList: list)
		invocations.append(action)
	}

	func performModification(_ modification: TodoModification, forTodos ids: [UUID]) throws {
		let action: Action = .performTodoModification(modification, forTodos: ids)
		invocations.append(action)
	}

	func performModification(_ modification: ListModification, forLists ids: [UUID]) throws {
		let action: Action = .performListModification(modification, forLists: ids)
		invocations.append(action)
	}

	func deleteTodos(with ids: [UUID]) throws {
		let action: Action = .deleteTodos(ids: ids)
		invocations.append(action)
	}
	
	func insertList(_ list: List) throws {
		let action: Action = .insertList(list: list)
		invocations.append(action)
	}

	func setList(title: String, with id: UUID) throws {
		let action: Action = .setList(title: title, withId: id)
		invocations.append(action)
	}

	func deleteLists(with ids: [UUID]) throws {
		let action: Action = .deleteLists(ids: ids)
		invocations.append(action)
	}
	
	func save() throws {
		let action: Action = .save
		invocations.append(action)
	}
}

// MARK: - Nested data structs
extension PersistentContainerMock {

	enum Action {
		case insertTodo(todo: Todo, toList: UUID?)
		case deleteTodos(ids: [UUID])
		case insertList(list: List)
		case deleteLists(ids: [UUID])
		case setList(title: String, withId: UUID)
		case performTodoModification(_ modification: TodoModification, forTodos: [UUID])
		case performListModification(_ modification: ListModification, forLists: [UUID])
		case save
	}
}
