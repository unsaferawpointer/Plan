//
//  TodosStateProviderMock.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 02.02.2024.
//

import Foundation
@testable import Plan

final class TodosStateProviderMock {

	private (set) var invocations: [Action] = []
}

// MARK: - TodosStateProviderProtocol
extension TodosStateProviderMock: TodosStateProviderProtocol {

	func selectTodos(_ ids: [UUID]) {
		let action: Action = .selectTodos(ids)
		invocations.append(action)
	}
}

extension TodosStateProviderMock {

	enum Action {
		case selectTodos(_ ids: [UUID])
	}
}
