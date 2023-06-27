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

	func addProject(_ project: ProjectItem) throws {
		if let error = errorStubs.addProject {
			throw error
		}
		invocations.append(.addProject(project))
	}

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
		case addProject(_ project: ProjectItem)
	}

	struct ErrorStubs {
		var fetchProjects: Error?
		var addProject: Error?
	}
}
