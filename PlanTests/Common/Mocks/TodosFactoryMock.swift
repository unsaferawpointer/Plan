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

	func createTodo(with text: String) -> Todo {
		return todoStub
	}
}
