//
//  ProjectsDataProviderMock.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 28.01.2024.
//

import Foundation
@testable import Plan

final class ProjectsDataProviderMock {

	private (set) var invocations: [Action] = []

	var errorStub: Error?
}

// MARK: - ProjectsDataProviderProtocol
extension ProjectsDataProviderMock: ProjectsDataProviderProtocol {

	func subscribe(_ object: ProjectsDataProviderDelegate) throws {
		guard let error = errorStub else {
			invocations.append(.subscribe(object))
			return
		}
		throw error
	}
}

// MARK: - Nested data structs
extension ProjectsDataProviderMock {

	enum Action {
		case subscribe(_ object: ProjectsDataProviderDelegate)
	}
}
