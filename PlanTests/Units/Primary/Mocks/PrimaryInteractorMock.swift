//
//  PrimaryInteractorMock.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 23.06.2023.
//

@testable import Plan

final class PrimaryInteractorMock {

	var invocations: [Action] = []

	var errorStubs = ErrorStubs()
}

// MARK: - PrimaryInteractor
extension PrimaryInteractorMock: PrimaryInteractor {

	func fetchProjects(sortBy sorting: [ProjectSorting]) throws {
		if let error = errorStubs.fetchProjects {
			throw error
		}
		invocations.append(.fetchProjects(sorting: sorting))
	}
}

// MARK: - Nested data structs
extension PrimaryInteractorMock {

	enum Action {
		case fetchProjects(sorting: [ProjectSorting])
	}

	struct ErrorStubs {
		var fetchProjects: Error?
	}
}
