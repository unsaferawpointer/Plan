//
//  SidebarPageSection.swift
//  PlanUITests
//
//  Created by Anton Cherkasov on 02.11.2024.
//

import XCTest

final class SidebarPageSection {

	var row: XCUIElement

	init(row: XCUIElement) {
		precondition(row.elementType == .outlineRow, "It is not outlineRow")
		self.row = row
	}
}

extension SidebarPageSection {

	var title: String? {
		return row.groups.descendants(matching: .staticText)["sidebar_section"].label
	}

	var isSelected: Bool {
		return row.isSelected
	}
}
