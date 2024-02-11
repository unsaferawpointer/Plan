//
//  SidebarStateProviderMock.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 02.02.2024.
//

import Foundation
@testable import Plan

final class SidebarStateProviderMock {

	private (set) var invocations: [Action] = []

	var routeStub: Route = .archieve
}

// MARK: - SidebarStateProviderProtocol
extension SidebarStateProviderMock: SidebarStateProviderProtocol {

	func navigate(to route: Route) {
		let action: Action = .navigate(route: route)
		invocations.append(action)
	}
	
	func getRoute() -> Route {
		routeStub
	}
}

extension SidebarStateProviderMock {

	enum Action {
		case navigate(route: Route)
	}
}
