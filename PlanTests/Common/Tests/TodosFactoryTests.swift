//
//  TodosFactoryTests.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 03.02.2024.
//

import XCTest
@testable import Plan

final class TodosFactoryTests: XCTestCase {

	private var sut: TodosFactory!

	override func setUpWithError() throws {
		sut = TodosFactory()
	}

	override func tearDownWithError() throws {
		sut = nil
	}
}

// MARK: - TodosFactoryProtocol
extension TodosFactoryTests {

	func testCreateTodoWhenConfigurationIsInFocus() {
		// Arrange
		let expectedText = UUID().uuidString

		sut = TodosFactory()

		// Act
		let result = sut.createTodo(with: expectedText, satisfyPredicate: .status(.inFocus))

		// Assert
		XCTAssertEqual(result.text, expectedText)
		guard case .inFocus = result.status else {
			return XCTFail()
		}
		XCTAssertNil(result.list)
	}

	func testCreateTodoWhenConfigurationIsBacklog() {
		// Arrange
		let expectedText = UUID().uuidString

		sut = TodosFactory()

		// Act
		let result = sut.createTodo(with: expectedText, satisfyPredicate: .status(.default))

		// Assert
		XCTAssertEqual(result.text, expectedText)
		guard case .default = result.status else {
			return XCTFail()
		}
		XCTAssertEqual(result.priority, .low)
		XCTAssertNil(result.list)
	}

	func testCreateTodoWhenConfigurationIsArchieve() {
		// Arrange
		let expectedText = UUID().uuidString

		sut = TodosFactory()

		// Act
		let result = sut.createTodo(with: expectedText, satisfyPredicate: .status(.done))

		// Assert
		XCTAssertEqual(result.text, expectedText)
		guard case .done = result.status else {
			return XCTFail()
		}
		XCTAssertEqual(result.priority, .low)
		XCTAssertNil(result.list)
	}

	func testCreateTodoWhenConfigurationIsLists() {
		// Arrange
		let expectedText = UUID().uuidString
		let expectedList = UUID()

		sut = TodosFactory()

		// Act
		let result = sut.createTodo(with: expectedText, satisfyPredicate: .list(expectedList))

		// Assert
		XCTAssertEqual(result.text, expectedText)
		guard case .default = result.status else {
			return XCTFail()
		}
		XCTAssertEqual(result.priority, .low)
		XCTAssertEqual(result.list, expectedList)
	}
}
