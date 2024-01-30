//
//  TodosViewMock.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 30.01.2024.
//

import Foundation
@testable import Plan

final class TodosViewMock {

	private (set) var invocations: [Action] = []
}

// MARK: - TodosView
extension TodosViewMock: TodosView {

	func display(_ items: [TodoModel]) {
		let action: Action = .display(items)
		invocations.append(action)
	}
}

// MARK: - Nested data structs
extension TodosViewMock {

	enum Action {
		case display(_ items: [TodoModel])
	}
}
