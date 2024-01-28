//
//  ProjectsPresenterMock.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 28.01.2024.
//

import Foundation
@testable import Plan

final class ProjectsPresenterMock {

	private (set) var invocations: [Action] = []
}

// MARK: - ProjectsPresenterProtocol
extension ProjectsPresenterMock: ProjectsPresenterProtocol {

	func present(_ projects: [Project]) {
		let action: Action = .present(projects)
		invocations.append(action)
	}
}

// MARK: - Nested data structs
extension ProjectsPresenterMock {

	enum Action {
		case present(_ projects: [Project])
	}
}
