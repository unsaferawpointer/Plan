//
//  ProjectsStateProviderMock.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 02.02.2024.
//

import Foundation
@testable import Plan

final class ProjectsStateProviderMock {

	private (set) var invocations: [Action] = []
}

// MARK: - ProjectsStateProviderProtocol
extension ProjectsStateProviderMock: ProjectsStateProviderProtocol {

	func selectProjects(_ ids: [UUID]) {
		let action: Action = .selectProjects(ids: ids)
		invocations.append(action)
	}
}

extension ProjectsStateProviderMock {

	enum Action {
		case selectProjects(ids: [UUID])
	}
}
