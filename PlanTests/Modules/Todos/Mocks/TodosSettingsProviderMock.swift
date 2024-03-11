//
//  TodosSettingsProviderMock.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 11.03.2024.
//

@testable import Plan

final class TodosSettingsProviderMock {

	var stubs: Stubs = .init()

	var invocations: [Action] = []
}

// MARK: - TodosSettingsProviderProtocol
extension TodosSettingsProviderMock: TodosSettingsProviderProtocol {

	func getGrouping(for behaviour: Behaviour) -> TodosGrouping {
		return stubs.grouping
	}
	
	func setGrouping(_ grouping: TodosGrouping, for behaviour: Behaviour) {
		invocations.append(.setGrouping(grouping))
	}

	var delegate: TodosSettingsDelegate? {
		get {
			stubs.delegate
		}
		set {
			invocations.append(.setDelegate(newValue))
		}
	}
}

// MARK: - Nested data structs
extension TodosSettingsProviderMock {

	enum Action {
		case setGrouping(_ grouping: TodosGrouping)
		case setDelegate(_ delegate: TodosSettingsDelegate?)
	}

	struct Stubs {
		var grouping: TodosGrouping = .none
		var delegate: TodosSettingsDelegate?
	}
}
