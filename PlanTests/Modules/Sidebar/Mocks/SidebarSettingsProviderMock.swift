//
//  SidebarSettingsProviderMock.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 25.03.2024.
//

@testable import Plan

final class SidebarSettingsProviderMock {

	private (set) var invocations: [Action] = []

	var stubs: Stubs = .init()
}

// MARK: - SidebarSettingsProviderProtocol
extension SidebarSettingsProviderMock: SidebarSettingsProviderProtocol {

	var selection: Route {
		get {
			stubs.selection
		}
		set(newValue) {
			invocations.append(.setSelection(newValue))
		}
	}
	
	var delegate: SidebarSettingsDelegate? {
		get {
			stubs.delegate
		}
		set(newValue) {
			invocations.append(.setDelegate(newValue))
		}
	}
}

// MARK: - Nested data structs
extension SidebarSettingsProviderMock {

	enum Action {
		case setSelection(_ value: Route)
		case setDelegate(_ value: SidebarSettingsDelegate?)
	}

	struct Stubs {
		var selection: Route = .inFocus
		var delegate: SidebarSettingsDelegate?
	}
}
