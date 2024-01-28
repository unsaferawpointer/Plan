//
//  ProjectsInteractorMock.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 28.01.2024.
//

import Foundation
@testable import Plan

final class ProjectsInteractorMock {

	private (set) var invocations: [Action] = []
}

// MARK: - ProjectsInteractorProtocol
extension ProjectsInteractorMock: ProjectsInteractorProtocol {

	func fetchProjects() throws {
		let action: Action = .fetchProjects
		invocations.append(action)
	}

	func setTitle(_ title: String, with id: UUID) throws {
		let action: Action = .setTitle(title: title, withId: id)
		invocations.append(action)
	}
}

// MARK: - Nested data structs
extension ProjectsInteractorMock {

	enum Action {
		case setTitle(title: String, withId: UUID)
		case fetchProjects
	}
}
