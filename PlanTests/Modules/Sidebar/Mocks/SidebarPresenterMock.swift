//
//  SidebarPresenterMock.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 11.02.2024.
//

import Foundation
@testable import Plan

final class SidebarPresenterMock {

	private (set) var invocations: [Action] = []
}

// MARK: - SidebarPresenterProtocol
extension SidebarPresenterMock: SidebarPresenterProtocol {

	func present(_ lists: [List]) {
		let action: Action = .present(lists)
		invocations.append(action)
	}
}

// MARK: - Nested data structs
extension SidebarPresenterMock {

	enum Action {
		case present(_ lists: [List])
	}
}
