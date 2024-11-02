//
//  SidebarPageRow.swift
//  PlanUITests
//
//  Created by Anton Cherkasov on 01.11.2024.
//

import XCTest

final class SidebarPageRow {

	var row: XCUIElement

	init(row: XCUIElement) {
		precondition(row.elementType == .outlineRow, "It is not outlineRow")
		self.row = row
	}
}

extension SidebarPageRow {

	var title: String? {
		return cell.staticTexts.firstMatch.value as? String
	}

	var cell: XCUIElement {
		return row.cells.firstMatch
	}

	var isSelected: Bool {
		return row.isSelected
	}
}
