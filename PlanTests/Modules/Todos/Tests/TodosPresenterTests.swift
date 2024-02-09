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

	private var infoDelegate: InfoDelegateMock!

	override func setUpWithError() throws {
		view = TodosViewMock()
		interactor = TodosInteractorMock()
		stateProvider = TodosStateProviderMock()
		infoDelegate = InfoDelegateMock()
		sut = TodosPresenter(stateProvider: stateProvider, infoDelegate: infoDelegate)
		sut.view = view
		sut.interactor = interactor
	}

	override func tearDownWithError() throws {
		sut = nil
		view = nil
		interactor = nil
		stateProvider = nil
		infoDelegate = nil
	}
}

// MARK: - test TodosPresenterProtocol
extension TodosPresenterTests {

	func testPresent() {
		// Arrange
		let todos: [Todo] = [.random, .random, .random]
		let expectedItems = todos.map { todo in
			TodoModel(
				uuid: todo.uuid,
				isDone: todo.isDone,
				isFavorite: todo.isFavorite,
				inFocus: todo.inFocus,
				text: todo.text
			)
		}

		// Act
		sut.present(todos)

		// Assert
		guard case let .display(state) = view.invocations[0] else {
			return XCTFail()
		}
		XCTAssertEqual(state, .content(models: expectedItems))
		XCTAssertEqual(view.invocations.count, 1)
		guard case let .infoDidChange(info) = infoDelegate.invocations[0] else {
			return XCTFail()
		}
		XCTAssertEqual(info, "3 incomplete todos")
	}

	func testPresentWhenDataIsEmpty() {
		// Arrange
		let todos: [Todo] = []

		// Act
		sut.present(todos)

		// Assert
		guard case let .display(state) = view.invocations[0] else {
			return XCTFail()
		}
		XCTAssertEqual(
			state,
				.placeholder(
					title: "No todos, yet",
					subtitle: "Add new todo using the plus button",
					image: "ghost"
				)
		)
		XCTAssertEqual(view.invocations.count, 1)
		guard case let .infoDidChange(info) = infoDelegate.invocations[0] else {
			return XCTFail()
		}
		XCTAssertEqual(info, "No incomplete todos")
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
		sut.createTodo()

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

// MARK: - TodosMenuDelegate
extension TodosPresenterTests {

	func testMenuItemHasBeenClickedWhenItemIsNewTodo() {
		// Act
		sut.menuItemHasBeenClicked(.newTodo)

		// Assert
		guard case let .performAction(action) = interactor.invocations[0] else {
			return XCTFail()
		}
		XCTAssertEqual(action, .insert(["New todo"]))
	}

	func testMenuItemHasBeenClickedWhenItemIsMarkAsCompleted() {
		// Arrange
		let expectedIds = [UUID(), UUID()]
		view.selectionStub = expectedIds

		// Act
		sut.menuItemHasBeenClicked(.markAsCompleted)

		// Assert
		guard case let .performModification(modification, ids) = interactor.invocations[0] else {
			return XCTFail()
		}
		XCTAssertEqual(modification, .setStatus(true))
		XCTAssertEqual(ids, expectedIds)
		XCTAssertEqual(interactor.invocations.count, 1)
	}

	func testMenuItemHasBeenClickedWhenItemIsMarkAsIncomplete() {
		// Arrange
		let expectedIds = [UUID(), UUID()]
		view.selectionStub = expectedIds

		// Act
		sut.menuItemHasBeenClicked(.markAsIncomplete)

		// Assert
		guard case let .performModification(modification, ids) = interactor.invocations[0] else {
			return XCTFail()
		}
		XCTAssertEqual(modification, .setStatus(false))
		XCTAssertEqual(ids, expectedIds)
		XCTAssertEqual(interactor.invocations.count, 1)
	}

	func testMenuItemHasBeenClickedWhenItemIsBookmark() {
		// Arrange
		let expectedIds = [UUID(), UUID()]
		view.selectionStub = expectedIds

		// Act
		sut.menuItemHasBeenClicked(.bookmark)

		// Assert
		guard case let .performModification(modification, ids) = interactor.invocations[0] else {
			return XCTFail()
		}
		XCTAssertEqual(modification, .bookmark)
		XCTAssertEqual(ids, expectedIds)
		XCTAssertEqual(interactor.invocations.count, 1)
	}

	func testMenuItemHasBeenClickedWhenItemIsUnbookmark() {
		// Arrange
		let expectedIds = [UUID(), UUID()]
		view.selectionStub = expectedIds

		// Act
		sut.menuItemHasBeenClicked(.unbookmark)

		// Assert
		guard case let .performModification(modification, ids) = interactor.invocations[0] else {
			return XCTFail()
		}
		XCTAssertEqual(modification, .unbookmark)
		XCTAssertEqual(ids, expectedIds)
		XCTAssertEqual(interactor.invocations.count, 1)
	}

	func testMenuItemHasBeenClickedWhenItemIsDelete() {
		// Arrange
		let expectedIds = [UUID(), UUID()]
		view.selectionStub = expectedIds

		// Act
		sut.menuItemHasBeenClicked(.delete)

		// Assert
		guard case let .performAction(action) = interactor.invocations[0] else {
			return XCTFail()
		}
		XCTAssertEqual(action, .delete(expectedIds))
		XCTAssertEqual(interactor.invocations.count, 1)
	}

	func testMenuItemHasBeenClickedWhenItemIsUUID() {
		// Arrange
		let expectedIds = [UUID(), UUID()]
		view.selectionStub = expectedIds

		let expectedProject = UUID()

		// Act
		sut.menuItemHasBeenClicked(.uuid(expectedProject))

		// Assert
		guard case let .performModification(modification, ids) = interactor.invocations[0] else {
			return XCTFail()
		}
		XCTAssertEqual(ids, expectedIds)
		XCTAssertEqual(modification, .setProject(expectedProject))
		XCTAssertEqual(interactor.invocations.count, 1)
	}
}
