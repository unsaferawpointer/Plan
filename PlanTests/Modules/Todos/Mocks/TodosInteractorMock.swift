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

	func fetchTodos() throws {
		let action: Action = .fetchTodos
		invocations.append(action)
	}
}

// MARK: - Nested data structs
extension TodosInteractorMock {

	enum Action {
		case fetchTodos
	}
}

