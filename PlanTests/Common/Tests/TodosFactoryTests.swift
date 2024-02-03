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

	func testCreateTodoWhenConfigurationIsInFocus() {
		// Arrange
		let expectedText = UUID().uuidString

		sut = TodosFactory(configuration: .inFocus)

		// Act
		let result = sut.createTodo(with: expectedText)

		// Assert
		XCTAssertEqual(result.text, expectedText)
		XCTAssertEqual(result.inFocus, true)
		XCTAssertEqual(result.isDone, false)
		XCTAssertNil(result.project)
	}

	func testCreateTodoWhenConfigurationIsBacklog() {
		// Arrange
		let expectedText = UUID().uuidString

		sut = TodosFactory(configuration: .backlog)

		// Act
		let result = sut.createTodo(with: expectedText)

		// Assert
		XCTAssertEqual(result.text, expectedText)
		XCTAssertEqual(result.inFocus, false)
		XCTAssertEqual(result.isDone, false)
		XCTAssertEqual(result.isFavorite, false)
		XCTAssertNil(result.project)
	}

	func testCreateTodoWhenConfigurationIsFavorites() {
		// Arrange
		let expectedText = UUID().uuidString

		sut = TodosFactory(configuration: .favorites)

		// Act
		let result = sut.createTodo(with: expectedText)

		// Assert
		XCTAssertEqual(result.text, expectedText)
		XCTAssertEqual(result.inFocus, false)
		XCTAssertEqual(result.isDone, false)
		XCTAssertEqual(result.isFavorite, true)
		XCTAssertNil(result.project)
	}

	func testCreateTodoWhenConfigurationIsArchieve() {
		// Arrange
		let expectedText = UUID().uuidString

		sut = TodosFactory(configuration: .archieve)

		// Act
		let result = sut.createTodo(with: expectedText)

		// Assert
		XCTAssertEqual(result.text, expectedText)
		XCTAssertEqual(result.inFocus, false)
		XCTAssertEqual(result.isDone, true)
		XCTAssertEqual(result.isFavorite, false)
		XCTAssertNil(result.project)
	}

	func testCreateTodoWhenConfigurationIsProject() {
		// Arrange
		let expectedText = UUID().uuidString
		let expectedProject = UUID()

		sut = TodosFactory(configuration: .project(expectedProject))

		// Act
		let result = sut.createTodo(with: expectedText)

		// Assert
		XCTAssertEqual(result.text, expectedText)
		XCTAssertEqual(result.inFocus, false)
		XCTAssertEqual(result.isDone, false)
		XCTAssertEqual(result.isFavorite, false)
		XCTAssertEqual(result.project, expectedProject)
	}
}
