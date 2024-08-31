//
//  PlanModelFactoryMock.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 31.08.2024.
//

@testable import Plan

final class PlanModelFactoryMock {
	var stubs = Stubs()
}

// MARK: - PlanModelFactoryProtocol
extension PlanModelFactoryMock: PlanModelFactoryProtocol {

	func makeModel(item: ItemContent, info: HierarchySnapshot.Info) -> HierarchyModel {
		guard let stub = stubs.model else {
			fatalError()
		}
		return stub
	}
}

extension PlanModelFactoryMock {

	struct Stubs {
		var model: HierarchyModel?
	}
}
