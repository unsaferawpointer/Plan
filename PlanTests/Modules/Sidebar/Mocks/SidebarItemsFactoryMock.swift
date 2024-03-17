//
//  SidebarItemsFactoryMock.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 17.03.2024.
//

import Foundation
@testable import Plan

final class SidebarItemsFactoryMock {

	var stubs = Stubs()
}

// MARK: - SidebarItemsFactoryProtocol
extension SidebarItemsFactoryMock: SidebarItemsFactoryProtocol {

	func makeStaticContent() -> [SidebarItem] {
		stubs.staticContent
	}
	
	func makeDynamicContent(from lists: [List]) -> [SidebarItem] {
		stubs.dynamicContent
	}
	
	func makeSectionTitle() -> String {
		stubs.sectionTitle
	}
}

// MARK: - Nested data structs
extension SidebarItemsFactoryMock {

	struct Stubs {
		var dynamicContent: [SidebarItem] = []
		var staticContent: [SidebarItem] = []
		var sectionTitle: String = UUID().uuidString
	}
}
