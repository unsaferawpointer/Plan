//
//  TodosPresenterTests.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 30.01.2024.
//

import XCTest
@testable import Plan

final class TodosPresenterTests: XCTestCase {

	private var sut: TodosPresenter!

	// MARK: - DI

	private var view: TodosViewMock!

	private var interactor: TodosInteractorMock!

	private var stateProvider: TodosStateProviderMock!

	override func setUpWithError() throws {
		view = TodosViewMock()
		interactor = TodosInteractorMock()
		stateProvider = TodosStateProviderMock()
		sut = TodosPresenter(stateProvider: stateProvider)
		sut.view = view
		sut.interactor = interactor
	}

	override func tearDownWithError() throws {
		sut = nil
		view = nil
		interactor = nil
	}
}

// MARK: - test TodosPresenterProtocol
extension TodosPresenterTests {

	func testPresent() {
		// Arrange
		let todos: [Todo] = [.random, .random, .random]
		let expectedItems = todos.map { todo in
			TodoModel(uuid: todo.uuid, isDone: todo.isDone, isFavorite: false, text: todo.text)
		}

		// Act
		sut.present(todos)

		// Assert
		guard case let .display(items) = view.invocations[0] else {
			return XCTFail()
		}
		XCTAssertEqual(expectedItems, items)
	}
}

// MARK: - TodosViewOutput
extension TodosPresenterTests {

	func testProviderDidChangeContent() {
		// Act
		sut.viewDidChange(state: .didLoad)

		// Assert
		guard case .fetchTodos = interactor.invocations[0] else {
			return XCTFail()
		}
	}

	func testToolbarNewTodoButtonHasBeenClicked() {
		// Act
		sut.toolbarNewTodoButtonHasBeenClicked()

		// Assert
		guard case let .performAction(action) = interactor.invocations[0] else {
			return XCTFail()
		}
		XCTAssertEqual(action, .insert(["New todo"]))
	}

	func testTextfieldDidChange() {
		// Arrange
		let expectedText = UUID().uuidString
		let expectedIds = [UUID(), UUID()]

		// Act
		sut.performModification(.setText(expectedText), forTodos: expectedIds)

		// Assert
		guard case let .performModification(modification, ids) = interactor.invocations[0] else {
			return XCTFail()
		}
		XCTAssertEqual(modification, .setText(expectedText))
		XCTAssertEqual(ids, expectedIds)
	}

	func testDelete() {
		// Arrange
		let expectedIds = [UUID(), UUID()]

		// Act
		sut.delete(expectedIds)

		// Assert
		guard case let .performAction(action) = interactor.invocations[0] else {
			return XCTFail()
		}
		XCTAssertEqual(action, .delete(expectedIds))
	}

	func testSelectionDidChange() {
		// Arrange
		let expectedIds = [UUID(), UUID()]

		// Act
		sut.selectionDidChange(expectedIds)

		// Assert
		guard case let .selectTodos(ids) = stateProvider.invocations[0] else {
			return XCTFail()
		}
		XCTAssertEqual(ids, expectedIds)
	}
}
