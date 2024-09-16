//
//  DocumentPage.swift
//  PlanUITests
//
//  Created by Anton Cherkasov on 23.08.2024.
//

import XCTest

final class DocumentPage {

	let window: XCUIElement

	let outline: XCUIElement

	init(window: XCUIElement) {
		precondition(window.elementType == .window, "It is not window")
		self.window = window
		self.outline = window.outlines.firstMatch
	}
}

// MARK: - Public interface
extension DocumentPage {

	func newItem(in targetRow: Int?) {
		if let row = targetRow {
			selectRow(row)
		}
		let toolbar =  window.toolbars.firstMatch
		XCTAssertTrue(toolbar.exists)
		let button = toolbar.buttons["new-toolbar-item"]
		button.click()
	}

	func newItems(count: Int, in targetRow: Int?) {
		if let row = targetRow {
			selectRow(row)
		}
		let toolbar =  window.toolbars.firstMatch
		XCTAssertTrue(toolbar.exists)
		let button = toolbar.buttons["new-toolbar-item"]
		for _ in 0..<count {
			button.click()
		}
	}

	func checkLeadingLabel(expectedTitle title: String) {
		let value = bottomBar().staticTexts["leading-label"].value
		XCTAssertEqual(title, value as? String)
	}

	func checkTrailingLabel(expectedTitle title: String) {
		let value = bottomBar().staticTexts["trailing-label"].value
		XCTAssertEqual(title, value as? String)
	}

	func checkProgress(expectedValue progress: Double) {
		let value = bottomBar().progressIndicators["progress"].value
		XCTAssertEqual(progress, value as? Double)
	}

	var rowsCount: Int {
		outline.outlineRows.count
	}

	func selectRow(_ index: Int) {
		let row = row(for: index)
		row.click()
	}

	func rightClick(_ index: Int) {
		let row = row(for: index)
		row.rightClick()
	}

	func dragRow(at index: Int, toRow targetIndex: Int) {

		let draggedRow = row(for: index).textFields.firstMatch
		let targetRow = row(for: targetIndex).textFields.firstMatch

		draggedRow.press(forDuration: 1, thenDragTo: targetRow)
	}

	var needToSave: Bool {
		return window.sheets.firstMatch.exists
	}

	func disclosedChildRowsCount(for index: Int) -> Int {
		let row = self.row(for: index)
		return row.disclosedChildRows.count
	}

	func close() {
		window.buttons[XCUIIdentifierCloseWindow].click()
		if needToSave {
			let savePanel = window.sheets.firstMatch
			let deleteButton = savePanel.buttons["DontSaveButton"]
			deleteButton.click()
		}
	}
}

// MARK: - Context menu support
extension DocumentPage {

	func invokeContextMenu(for index: Int, andClick item: String) {

		let row = self.row(for: index)
		row.rightClick()

		outline.menuItems[item].click()
	}

	func menuItem(for id: String, block: (XCUIElement) -> Void) {
		let menu = outline.menus["outline_context_menu"]
		guard menu.exists else {
			XCTFail("The context menu is missing.")
			return
		}
		block(menu.menuItems[id])
	}
}

// MARK: - Helpers
private extension DocumentPage {

	func row(for index: Int) -> XCUIElement {
		return outline
			.children(matching: .outlineRow)
			.element(boundBy: index)
	}

	func bottomBar() -> XCUIElement {
		return window.otherElements["bottom-bar"]
	}
}
