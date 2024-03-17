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

	func display(staticContent: [SidebarItem]) {
		let action: Action = .displayStaticContent(staticContent)
		invocations.append(action)
	}
	
	func display(sectionTitle: String, dynamicContent: [SidebarItem]) {
		let action: Action = .displayDynamicContent(
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
		case displayStaticContent(_ content: [SidebarItem])
		case displayDynamicContent(sectionTitle: String, dynamicContent: [SidebarItem])
		case selectItem(_ id: Route)
	}
}
