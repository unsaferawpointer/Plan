//
//  SidebarPage.swift
//  PlanUITests
//
//  Created by Anton Cherkasov on 01.11.2024.
//

import XCTest

final class SidebarPage {

	var outline: XCUIElement

	init(outline: XCUIElement) {
		precondition(outline.elementType == .outline, "It is not outline")
		self.outline = outline
	}
}

extension SidebarPage {

	func section(for index: Int) -> SidebarPageSection {
		let element = outline
			.children(matching: .outlineRow)
			.element(boundBy: index)
		return SidebarPageSection(row: element)
	}

	func row(for index: Int) -> SidebarPageRow {
		let element = outline
			.children(matching: .outlineRow)
			.element(boundBy: index)
		return SidebarPageRow(row: element)
	}
}
