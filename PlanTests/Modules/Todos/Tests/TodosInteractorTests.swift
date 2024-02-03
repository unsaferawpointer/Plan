//
//  TodosInteractorTests.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 30.01.2024.
//

import XCTest
@testable import Plan

final class TodosInteractorTests: XCTestCase {

	private var sut: TodosInteractor!

	// MARK: - DI

	private var presenter: TodosPresenterMock!

	private var provider: TodosDataProviderMock!

	private var storage: PersistentContainerMock!

	private var factory: TodosFactoryMock!

	override func setUpWithError() throws {
		presenter = TodosPresenterMock()
		provider = TodosDataProviderMock()
		storage = PersistentContainerMock()
		factory = TodosFactoryMock()
		sut = TodosInteractor(
			presenter: presenter,
			provider: provider,
			storage: storage, 
			factory: factory
		)
	}

	override func tearDownWithError() throws {
		sut = nil
		presenter = nil
		provider = nil
		storage = nil
		factory = nil
	}
}

// MARK: - test TodosInteractorProtocol
extension TodosInteractorTests {

	func testFetchTodos() {
		// Arrange
		var expectedError: Error?
		provider.errorStub = nil

		// Act
		do {
			try sut.fetchTodos()
		} catch {
			expectedError = error
		}

		// Assert
		XCTAssertNil(expectedError)
		guard case let .subscribe(object) = provider.invocations[0] else {
			return XCTFail()
		}
		XCTAssertIdentical(sut, object)
	}

	func testCreateTodo() {
		let expectedText = UUID().uuidString
		var expectedError: Error?

		let expectedTodo: Todo = .random
		factory.todoStub = expectedTodo

		// Act
		do {
			try sut.createTodo(withText: expectedText)
		} catch {
			expectedError = error
		}

		// Assert
		XCTAssertNil(expectedError)
		guard case let .insertTodo(todo, project) = storage.invocations[0] else {
			return XCTFail()
		}
		XCTAssertEqual(todo, expectedTodo)
		XCTAssertNil(project)
		guard case .save = storage.invocations[1] else {
			return XCTFail()
		}
		XCTAssertEqual(storage.invocations.count, 2)
	}

	func testSetTitle() {
		// Arrange
		let expectedText = UUID().uuidString
		let expectedId = UUID()
		var expectedError: Error?
		provider.errorStub = nil

		// Act
		do {
			try sut.setText(expectedText, forTodo: expectedId)
		} catch {
			expectedError = error
		}

		// Assert
		XCTAssertNil(expectedError)
		guard case let .setTodo(text, id) = storage.invocations[0] else {
			return XCTFail()
		}
		XCTAssertEqual(text, expectedText)
		XCTAssertEqual(id, expectedId)
		guard case .save = storage.invocations[1] else {
			return XCTFail()
		}
		XCTAssertEqual(storage.invocations.count, 2)
	}

	func testDeleteTodo() {
		// Arrange
		let expectedIds = [UUID(), UUID()]
		var expectedError: Error?
		provider.errorStub = nil

		// Act
		do {
			try sut.deleteTodos(withIds: expectedIds)
		} catch {
			expectedError = error
		}

		// Assert
		XCTAssertNil(expectedError)
		guard case let .deleteTodos(ids) = storage.invocations[0] else {
			return XCTFail()
		}
		XCTAssertEqual(ids, expectedIds)
		guard case .save = storage.invocations[1] else {
			return XCTFail()
		}
		XCTAssertEqual(storage.invocations.count, 2)
	}
}

// MARK: - TodosDataProviderDelegate
extension TodosInteractorTests {

	func testProviderDidChangeContent() {
		// Arrange
		let todos: [Todo] = [.random, .random, .random]

		// Act
		sut.providerDidChangeContent(todos)

		// Assert
		guard case let .present(content) = presenter.invocations[0] else {
			return XCTFail()
		}
		XCTAssertEqual(content, todos)
	}
}
