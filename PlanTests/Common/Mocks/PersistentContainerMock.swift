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

	func insertTodo(_ todo: Todo, to project: UUID?) throws {
		let action: Action = .insertTodo(todo: todo, toProject: project)
		invocations.append(action)
	}

	func setTodo(text: String, with id: UUID) throws {
		let action: Action = .setTodo(text: text, withId: id)
		invocations.append(action)
	}

	func deleteTodos(with ids: [UUID]) throws {
		let action: Action = .deleteTodos(ids: ids)
		invocations.append(action)
	}
	
	func insertProject(_ project: Project) throws {
		let action: Action = .insertProject(project: project)
		invocations.append(action)
	}

	func setProject(title: String, with id: UUID) throws {
		let action: Action = .setProject(title: title, withId: id)
		invocations.append(action)
	}

	func deleteProjects(with ids: [UUID]) throws {
		let action: Action = .deleteProjects(ids: ids)
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
		case insertTodo(todo: Todo, toProject: UUID?)
		case setTodo(text: String, withId: UUID)
		case deleteTodos(ids: [UUID])
		case insertProject(project: Project)
		case setProject(title: String, withId: UUID)
		case deleteProjects(ids: [UUID])
		case save
	}
}
