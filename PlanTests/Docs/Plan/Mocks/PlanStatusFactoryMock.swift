//
//  PlanStatusFactoryMock.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 31.08.2024.
//

@testable import Plan

final class PlanStatusFactoryMock {

	var stubs = Stubs()
}

// MARK: - PlanStatusFactoryProtocol
extension PlanStatusFactoryMock: PlanStatusFactoryProtocol {

	func makeModel(for nodes: [Node<ItemContent>]) -> BottomBar.Model {
		stubs.model
	}
}

// MARK: - Nested data structs
extension PlanStatusFactoryMock {

	struct Stubs {
		var model = BottomBar.Model()
	}
}
