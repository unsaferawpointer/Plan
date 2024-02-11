//
//  SidebarStateProviderMock.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 02.02.2024.
//

import Foundation
@testable import Plan

final class SidebarStateProviderMock {

	private (set) var invocations: [Action] = []
}

// MARK: - SidebarStateProviderProtocol
extension SidebarStateProviderMock: SidebarStateProviderProtocol {

	func selectLists(_ ids: [UUID]) {
		let action: Action = .selectLists(ids: ids)
		invocations.append(action)
	}
}

extension SidebarStateProviderMock {

	enum Action {
		case selectLists(ids: [UUID])
	}
}
