//
//  ListsDataProviderMock.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 28.01.2024.
//

import Foundation
@testable import Plan

final class ListsDataProviderMock {

	private (set) var invocations: [Action] = []

	var errorStub: Error?
}

// MARK: - ListsDataProviderProtocol
extension ListsDataProviderMock: ListsDataProviderProtocol {

	func subscribe(_ object: ListsDataProviderDelegate) throws {
		guard let error = errorStub else {
			invocations.append(.subscribe(object))
			return
		}
		throw error
	}
}

// MARK: - Nested data structs
extension ListsDataProviderMock {

	enum Action {
		case subscribe(_ object: ListsDataProviderDelegate)
	}
}
