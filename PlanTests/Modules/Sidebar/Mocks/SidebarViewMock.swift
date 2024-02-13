//
//  SidebarViewMock.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 11.02.2024.
//

import Foundation
@testable import Plan

final class SidebarViewMock {

	private (set) var invocations: [Action] = []

	var clickedItemStub: Route?
}

// MARK: - TodosView
extension SidebarViewMock: SidebarView {

	func display(staticContent: [SidebarItem], sectionTitle: String, dynamicContent: [SidebarItem]) {
		let action: Action = .display(
			staticContent: staticContent,
			sectionTitle: sectionTitle,
			dynamicContent: dynamicContent
		)
		invocations.append(action)
	}

	func selectItem(_ id: Route) {
		let action: Action = .selectItem(id)
		invocations.append(action)
	}

	func clickedItem() -> Route? {
		clickedItemStub
	}
}

// MARK: - Nested data structs
extension SidebarViewMock {

	enum Action {
		case display(staticContent: [SidebarItem], sectionTitle: String, dynamicContent: [SidebarItem])
		case selectItem(_ id: Route)
	}
}
