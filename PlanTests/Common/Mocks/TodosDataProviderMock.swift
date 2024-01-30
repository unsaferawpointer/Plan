//
//  TodosDataProviderMock.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 30.01.2024.
//

import Foundation
@testable import Plan

final class TodosDataProviderMock {

	private (set) var invocations: [Action] = []

	var errorStub: Error?
}

// MARK: - TodosDataProviderProtocol
extension TodosDataProviderMock: TodosDataProviderProtocol {

	func subscribe(_ object: TodosDataProviderDelegate) throws {
		guard let error = errorStub else {
			invocations.append(.subscribe(object))
			return
		}
		throw error
	}
}

// MARK: - Nested data structs
extension TodosDataProviderMock {

	enum Action {
		case subscribe(_ object: TodosDataProviderDelegate)
	}
}
