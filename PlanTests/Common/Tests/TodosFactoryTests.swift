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
		sut = TodosFactory(configuration: .backlog)
	}

	override func tearDownWithError() throws {
		sut = nil
	}
}

// MARK: - TodosFactoryProtocol
extension TodosFactoryTests {

	func testCreateTodoWhenConfigurationIsInProgress() {
		// Arrange
		let expectedText = UUID().uuidString

		sut = TodosFactory(configuration: .inProgress)

		// Act
		let result = sut.createTodo(with: expectedText)

		// Assert
		XCTAssertEqual(result.text, expectedText)
		guard case .inProgress = result.status else {
			return XCTFail()
		}
		XCTAssertNil(result.list)
	}

	func testCreateTodoWhenConfigurationIsBacklog() {
		// Arrange
		let expectedText = UUID().uuidString

		sut = TodosFactory(configuration: .backlog)

		// Act
		let result = sut.createTodo(with: expectedText)

		// Assert
		XCTAssertEqual(result.text, expectedText)
		guard case .incomplete = result.status else {
			return XCTFail()
		}
		XCTAssertEqual(result.isFavorite, false)
		XCTAssertNil(result.list)
	}

	func testCreateTodoWhenConfigurationIsFavorites() {
		// Arrange
		let expectedText = UUID().uuidString

		sut = TodosFactory(configuration: .favorites)

		// Act
		let result = sut.createTodo(with: expectedText)

		// Assert
		XCTAssertEqual(result.text, expectedText)
		guard case .incomplete = result.status else {
			return XCTFail()
		}
		XCTAssertEqual(result.isFavorite, true)
		XCTAssertNil(result.list)
	}

	func testCreateTodoWhenConfigurationIsArchieve() {
		// Arrange
		let expectedText = UUID().uuidString

		sut = TodosFactory(configuration: .archieve)

		// Act
		let result = sut.createTodo(with: expectedText)

		// Assert
		XCTAssertEqual(result.text, expectedText)
		guard case .isDone = result.status else {
			return XCTFail()
		}
		XCTAssertEqual(result.isFavorite, false)
		XCTAssertNil(result.list)
	}

	func testCreateTodoWhenConfigurationIsLists() {
		// Arrange
		let expectedText = UUID().uuidString
		let expectedList = UUID()

		sut = TodosFactory(configuration: .list(expectedList))

		// Act
		let result = sut.createTodo(with: expectedText)

		// Assert
		XCTAssertEqual(result.text, expectedText)
		guard case .incomplete = result.status else {
			return XCTFail()
		}
		XCTAssertEqual(result.isFavorite, false)
		XCTAssertEqual(result.list, expectedList)
	}
}
