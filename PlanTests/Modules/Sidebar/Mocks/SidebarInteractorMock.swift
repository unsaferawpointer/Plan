//
//  SidebarInteractorMock.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 11.02.2024.
//

import Foundation
@testable import Plan

final class SidebarInteractorMock {

	private (set) var invocations: [Action] = []
}

// MARK: - SidebarInteractorProtocol
extension SidebarInteractorMock: SidebarInteractorProtocol {

	func fetchLists() throws {
		let action: Action = .fetchLists
		invocations.append(action)
	}
	
	func perform(_ modification: Plan.ListModification, forLists ids: [UUID]) throws {
		let action: Action = .perform(modification, forLists: ids)
		invocations.append(action)
	}
}

// MARK: - Nested data structs
extension SidebarInteractorMock {

	enum Action {
		case fetchLists
		case perform(_ modification: ListModification, forLists: [UUID])
	}
}
