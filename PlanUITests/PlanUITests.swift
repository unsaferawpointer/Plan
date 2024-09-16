//
//  PlanUITests.swift
//  PlanUITests
//
//  Created by Anton Cherkasov on 04.08.2024.
//

import XCTest

final class PlanUITests: XCTestCase {

	override func setUpWithError() throws {
		continueAfterFailure = false
	}

	override func tearDownWithError() throws {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}
}

// MARK: - Creation
extension PlanUITests {

	func test_createFlatList() {
		//Arrange
		let app = prepareApp()

		let window = app.firstWindow()

		let doc = DocumentPage(window: window)

		// Act
		doc.newItems(count: 3, in: nil)

		// Assert
		XCTAssertEqual(doc.rowsCount, 3)
		doc.checkLeadingLabel(expectedTitle: "3 tasks")
		doc.checkTrailingLabel(expectedTitle: "0 %")
		doc.checkProgress(expectedValue: 0)
	}

	func test_createNestedList() {
		//Arrange
		let app = prepareApp()

		let window = app.firstWindow()

		let doc = DocumentPage(window: window)

		// Act
		doc.newItems(count: 1, in: nil)
		doc.newItems(count: 1, in: 0)
		doc.newItems(count: 1, in: 1)

		// Assert
		XCTAssertEqual(doc.rowsCount, 3)
		doc.checkLeadingLabel(expectedTitle: "1 task")
		doc.checkTrailingLabel(expectedTitle: "0 %")
		doc.checkProgress(expectedValue: 0)
	}

	func test_createNewItem() {
		//Arrange
		let app = prepareApp()

		let window = app.firstWindow()

		let doc = DocumentPage(window: window)

		// Act
		doc.newItems(count: 1, in: nil)

		// Assert
		XCTAssertEqual(doc.rowsCount, 1)
		doc.checkLeadingLabel(expectedTitle: "1 task")
		doc.checkTrailingLabel(expectedTitle: "0 %")
		doc.checkProgress(expectedValue: 0)
	}

	func test_createNewItem_whenPressShortcut() {
		//Arrange
		let app = prepareApp()

		let window = app.firstWindow()

		let doc = DocumentPage(window: window)

		// Act
		doc.newItems(count: 1, in: nil)
		doc.selectRow(0)
		app.press("t", modifierFlags: [.command])

		// Assert
		XCTAssertEqual(doc.rowsCount, 2)
	}
}

// MARK: - Context Menu
extension PlanUITests {

	func test_checkContextMenu() {
		//Arrange
		let app = prepareApp()

		let window = app.firstWindow()

		let doc = DocumentPage(window: window)
		doc.newItems(count: 1, in: nil)

		// Act
		doc.rightClick(0)

		// Assert
		doc.menuItem(for: "new_menu_item") {
			XCTAssertTrue($0.isEnabled)
			XCTAssertEqual($0.title, "New")
		}
		doc.menuItem(for: "bookmark_menu_item") {
			XCTAssertTrue($0.isEnabled)
			XCTAssertEqual($0.title, "Bookmarked")
		}
		doc.menuItem(for: "set_status_menu_item") {
			XCTAssertTrue($0.isEnabled)
			XCTAssertEqual($0.title, "Completed")
		}
		doc.menuItem(for: "copy_menu_item") {
			XCTAssertTrue($0.isEnabled)
			XCTAssertEqual($0.title, "Copy")
		}
		doc.menuItem(for: "paste_menu_item") {
			XCTAssertTrue($0.isEnabled)
			XCTAssertEqual($0.title, "Paste")
		}
		doc.menuItem(for: "number_menu_item") {
			XCTAssertTrue($0.isEnabled)
			XCTAssertEqual($0.title, "Number")
		}
		doc.menuItem(for: "icon_menu_item") {
			XCTAssertTrue($0.isEnabled)
			XCTAssertEqual($0.title, "Icon")
		}
		doc.menuItem(for: "delete_menu_item") {
			XCTAssertTrue($0.isEnabled)
			XCTAssertEqual($0.title, "Delete")
		}
	}

	func test_clickNewMenuItem() {
		//Arrange
		let app = prepareApp()

		let window = app.firstWindow()

		let doc = DocumentPage(window: window)
		doc.newItems(count: 1, in: nil)

		// Act
		doc.selectRow(0)
		doc.invokeContextMenu(for: 0, andClick: .newMenuItem)

		// Assert
		XCTAssertEqual(doc.rowsCount, 2)
		XCTAssertEqual(doc.disclosedChildRowsCount(for: 0), 1)
		XCTAssertEqual(doc.disclosedChildRowsCount(for: 1), 0)
	}

	func test_clickStatusMenuItem() {
		//Arrange
		let app = prepareApp()

		let window = app.firstWindow()

		let doc = DocumentPage(window: window)
		doc.newItems(count: 1, in: nil)

		// Act
		doc.selectRow(0)
		doc.invokeContextMenu(for: 0, andClick: .statusMenuItem)

		// Assert
		XCTAssertEqual(doc.rowsCount, 1)
		doc.checkLeadingLabel(expectedTitle: "All tasks completed")
		doc.checkTrailingLabel(expectedTitle: "100 %")
		doc.checkProgress(expectedValue: 1)
	}

	func test_clickDeleteMenuItem() {
		//Arrange
		let app = prepareApp()

		let window = app.firstWindow()

		let doc = DocumentPage(window: window)

		doc.newItems(count: 1, in: nil)
		doc.newItems(count: 1, in: 0)
		doc.newItems(count: 1, in: 1)

		// Act
		doc.selectRow(0)
		doc.invokeContextMenu(for: 0, andClick: .deleteMenuItem)

		// Assert
		XCTAssertEqual(doc.rowsCount, 0)
	}

}

// MARK: - Helpers
private extension PlanUITests {

	func prepareApp() -> AppPage {
		let app = AppPage(app: XCUIApplication())

		app.launch()
		app.closeAll()

		app.newDoc()

		return app
	}
}

private extension String {
	static var deleteMenuItem = "delete_menu_item"
	static var newMenuItem = "new_menu_item"
	static var statusMenuItem = "set_status_menu_item"
}
