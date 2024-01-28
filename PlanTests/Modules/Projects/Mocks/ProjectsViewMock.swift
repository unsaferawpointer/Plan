//
//  ProjectsViewMock.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 28.01.2024.
//

import Foundation
@testable import Plan

final class ProjectsViewMock {

	private (set) var invocations: [Action] = []
}

// MARK: - ProjectsView
extension ProjectsViewMock: ProjectsView {

	func display(_ items: [ProjectConfiguration]) {
		let action: Action = .display(items)
		invocations.append(action)
	}
}

// MARK: - Nested data structs
extension ProjectsViewMock {

	enum Action {
		case display(_ items: [ProjectConfiguration])
	}
}
