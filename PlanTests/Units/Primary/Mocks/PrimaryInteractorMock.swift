//
//  PrimaryInteractorMock.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 23.06.2023.
//

import Foundation
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

	func renameProject(id: UUID, newName: String) throws {
		if let error = errorStubs.addProject {
			throw error
		}
		invocations.append(.renameProject(id: id, newName: newName))
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
		case renameProject(id: UUID, newName: String)
	}

	struct ErrorStubs {
		var fetchProjects: Error?
		var addProject: Error?
		var renameProject: Error?
	}
}
