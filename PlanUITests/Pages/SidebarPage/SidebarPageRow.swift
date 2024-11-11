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

	var value: String? {
		return cell.staticTexts["sidebar_label"].value as? String
	}

	var label: String? {
		return cell.staticTexts["sidebar_label"].label 
	}

	var cell: XCUIElement {
		return row.cells.firstMatch
	}

	var isSelected: Bool {
		return row.isSelected
	}
}
