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

	override func setUpWithError() throws {
		presenter = TodosPresenterMock()
		provider = TodosDataProviderMock()
		storage = PersistentContainerMock()
		sut = TodosInteractor(
			presenter: presenter,
			provider: provider,
			storage: storage
		)
	}

	override func tearDownWithError() throws {
		sut = nil
		presenter = nil
		provider = nil
		storage = nil
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
