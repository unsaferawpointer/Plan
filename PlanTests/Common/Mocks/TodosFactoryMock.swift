//
//  TodosFactoryMock.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 03.02.2024.
//

import Foundation
@testable import Plan

final class TodosFactoryMock {

	var todoStub: Todo = .random
}

// MARK: - TodosFactoryProtocol
extension TodosFactoryMock: TodosFactoryProtocol {

	func createTodo(with id: UUID, text: String, satisfyPredicate predicate: Plan.TodosPredicate) -> Plan.Todo {
		todoStub
	}

}
