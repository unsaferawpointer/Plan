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

	let splitGroup: XCUIElement

	let bottomBar: BottomBarPage

	init(window: XCUIElement) {
		_ = window.waitForExistence(timeout: 0.5)
		precondition(window.elementType == .window, "It is not window")
		self.window = window
		self.outline = window.outlines.firstMatch
		self.splitGroup = window.splitGroups.firstMatch
		self.bottomBar = BottomBarPage(element: window.groups["bottom-bar"])
	}
}

// MARK: - Public interface
extension DocumentPage {

	func checkTitle(_ title: String) -> Bool {
		return window.staticTexts[title].exists
	}

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
		outline.click()
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

	var rowsCount: Int {
		outline.outlineRows.count
	}

	func selectRow(_ index: Int) {
		let row = row(for: index)
		guard row.waitForExistence(timeout: 0.5) else {
			return
		}
		row.cells.element(boundBy: 0).click()
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
		let button = window.buttons[XCUIIdentifierCloseWindow]
		guard button.waitForExistence(timeout: 0.2), button.isHittable else {
			return
		}
		button.click()
		if needToSave {
			let savePanel = window.sheets.firstMatch
			let deleteButton = savePanel.buttons["DontSaveButton"]
			deleteButton.click()
		}
	}

	func savePanelExists() -> Bool {
		return window.sheets.firstMatch.exists
	}

	func clickSavePanelCancleButton() {
		let savePanel = window.sheets.firstMatch
		let cancelButton = savePanel.buttons["CancelButton"]
		cancelButton.firstMatch.click()
	}
}

// MARK: - Sidebar support
extension DocumentPage {

	var sidebar: SidebarPage {
		return SidebarPage(outline: window.outlines["sidebar"])
	}

	func toggleSidebar() {
		let toolbar =  window.toolbars.firstMatch
		let button = toolbar.buttons["sidebar-toolbar-item"]
		button.click()
	}
}

// MARK: - Context menu support
extension DocumentPage {

	func invokeContextMenu(for index: Int, andClick item: String) {

		let row = self.row(for: index)
		row.cells.element(boundBy: 0).rightClick()

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
}
