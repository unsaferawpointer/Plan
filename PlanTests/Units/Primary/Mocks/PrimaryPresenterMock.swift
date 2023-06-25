//
//  PrimaryPresenterMock.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 25.06.2023.
//

@testable import Plan

final class PrimaryPresenterMock {

	var invocations: [Action] = []
}

// MARK: - PrimaryPresenter
extension PrimaryPresenterMock: PrimaryPresenter {

	func present(_ projects: [ProjectItem]) {
		invocations.append(.present(projects))
	}
}

// MARK: - Nested data structs
extension PrimaryPresenterMock {

	enum Action {
		case present(_ projects: [ProjectItem])
	}
}
