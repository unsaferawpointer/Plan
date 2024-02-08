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

	var selectionStub: [UUID] = []
}

// MARK: - TodosView
extension TodosViewMock: TodosView {

	var selection: [UUID] {
		selectionStub
	}

	func display(_ state: TodosViewState) {
		let action: Action = .display(state)
		invocations.append(action)
	}
}

// MARK: - Nested data structs
extension TodosViewMock {

	enum Action {
		case display(_ state: TodosViewState)
	}
}
