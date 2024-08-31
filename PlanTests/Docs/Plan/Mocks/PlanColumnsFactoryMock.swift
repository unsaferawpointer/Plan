//
//  PlanColumnsFactoryMock.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 31.08.2024.
//

@testable import Plan

final class PlanColumnsFactoryMock {
	var stubs = Stubs()
}

// MARK: - PlanColumnsFactoryProtocol
extension PlanColumnsFactoryMock: PlanColumnsFactoryProtocol {

	func makeColumns(delegate: PlanColumnsFactoryDelegate) -> [any TableColumn<HierarchyModel>] {
		stubs.columns
	}
}

extension PlanColumnsFactoryMock {

	struct Stubs {
		var columns: [any TableColumn<HierarchyModel>] = []
	}
}
