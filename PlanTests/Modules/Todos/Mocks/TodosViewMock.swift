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

	func focusOn(id: UUID) {
		let action: Action = .focusOn(id: id)
		invocations.append(action)
	}
	
	func scrollTo(id: UUID) {
		let action: Action = .scrollTo(id: id)
		invocations.append(action)
	}

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
		case focusOn(id: UUID)
		case scrollTo(id: UUID)
	}
}
