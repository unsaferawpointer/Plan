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
		XCTAssertEqual(doc.rowsCount, 3)
		doc.checkLeadingLabel(expectedTitle: "1 task")
		doc.checkTrailingLabel(expectedTitle: "0 %")
		doc.checkProgress(expectedValue: 0)
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
