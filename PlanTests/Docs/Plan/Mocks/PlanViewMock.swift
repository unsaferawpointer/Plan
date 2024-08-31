//
//  PlanViewMock.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 31.08.2024.
//

import Foundation
@testable import Plan

final class PlanViewMock {
	var invocations: [Action] = []
	var stubs = Stubs()
}

// MARK: - PlanView
extension PlanViewMock: PlanView {

	func display(_ model: PlanModel) {
		invocations.append(.display(model))
	}
	
	func setConfiguration(_ configuration: DropConfiguration) {
		invocations.append(.setDropConfiguration(configuration))
	}
	
	func setConfiguration(_ columns: [any TableColumn<HierarchyModel>]) {
		invocations.append(.setColumnsConfiguration(columns))
	}
	
	func scroll(to id: UUID) {
		invocations.append(.scroll(id: id))
	}
	
	func select(_ id: UUID) {
		invocations.append(.select(id))
	}
	
	func expand(_ ids: [UUID]) {
		invocations.append(.expand(ids))
	}
	
	func expandAll() {
		invocations.append(.expandAll)
	}
	
	func collapse(_ ids: [UUID]) {
		invocations.append(.collapse(ids))
	}
	
	func focus(on id: UUID) {
		invocations.append(.focus(id: id))
	}
	
	var selection: [UUID] {
		set {
			invocations.append(.didSetSelection(newValue))
		}
		get {
			stubs.selection
		}
	}

}

// MARK: - Nested data structs
extension PlanViewMock {

	enum Action {
		case display(_ model: PlanModel)
		case setDropConfiguration(_ configuration: DropConfiguration)
		case setColumnsConfiguration(_ columns: [any TableColumn<HierarchyModel>])
		case scroll(id: UUID)
		case select(_ id: UUID)
		case expand(_ ids: [UUID])
		case expandAll
		case collapse(_ ids: [UUID])
		case focus(id: UUID)
		case didSetSelection(_ value: [UUID])
	}

	struct Stubs {
		var selection: [UUID] = []
	}
}
