//
//  PrimaryViewMock.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 24.06.2023.
//

@testable import Plan

final class PrimaryViewMock {

	var invocations: [Action] = []
}

// MARK: - PrimaryView
extension PrimaryViewMock: PrimaryView {

	func display(_ sections: [Primary.SectionModel]) {
		invocations.append(.display(sections))
	}
}

// MARK: - Nested data structs
extension PrimaryViewMock {

	enum Action {
		case display(_ sections: [Primary.SectionModel])
	}
}
