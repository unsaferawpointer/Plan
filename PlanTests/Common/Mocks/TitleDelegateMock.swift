//
//  TitleDelegateMock.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 11.02.2024.
//

import Foundation
@testable import Plan

final class TitleDelegateMock {
	private (set) var invocations: [Action] = []
}

// MARK: - TitleDelegate
extension TitleDelegateMock: TitleDelegate {

	func titleDidChange(_ title: String) {
		let action: Action = .titleDidChange(title)
		invocations.append(action)
	}
}

// MARK: - Nested data structs
extension TitleDelegateMock {

	enum Action {
		case titleDidChange(_ title: String)
	}
}
