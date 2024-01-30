//
//  TodosPresenterMock.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 30.01.2024.
//

import Foundation
@testable import Plan

final class TodosPresenterMock {

	private (set) var invocations: [Action] = []
}

// MARK: - TodosPresenterProtocol
extension TodosPresenterMock: TodosPresenterProtocol {

	func present(_ todos: [Todo]) {
		let action: Action = .present(todos)
		invocations.append(action)
	}

}

// MARK: - Nested data structs
extension TodosPresenterMock {

	enum Action {
		case present(_ todos: [Todo])
	}
}
