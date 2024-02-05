//
//  InfoDelegateMock.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 05.02.2024.
//

import Foundation
@testable import Plan

final class InfoDelegateMock {
	private (set) var invocations: [Action] = []
}

// MARK: - InfoDelegate
extension InfoDelegateMock: InfoDelegate {

	func infoDidChange(_ info: String) {
		let action: Action = .infoDidChange(info)
		invocations.append(action)
	}
}

// MARK: - Nested data structs
extension InfoDelegateMock {

	enum Action {
		case infoDidChange(_ info: String)
	}
}
