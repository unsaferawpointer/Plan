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

	func perform(_ action: TodosAction) throws {
		let action: Action = .performAction(action)
		invocations.append(action)
	}
	
	func perform(_ modification: TodoModification, forTodos ids: [UUID]) throws {
		let action: Action = .performModification(modification, forTodos: ids)
		invocations.append(action)
	}

	func fetchTodos() throws {
		let action: Action = .fetchTodos
		invocations.append(action)
	}
}

// MARK: - Nested data structs
extension TodosInteractorMock {

	enum Action {
		case fetchTodos
		case performAction(_ action: TodosAction)
		case performModification(_ modification: TodoModification, forTodos: [UUID])
	}
}

