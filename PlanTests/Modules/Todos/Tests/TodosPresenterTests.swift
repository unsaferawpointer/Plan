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

	private var infoDelegate: InfoDelegateMock!

	private var settingsProvider: TodosSettingsProviderMock!

	private var itemsFactory: TodoItemsFactoryMock!

	override func setUpWithError() throws {
		view = TodosViewMock()
		interactor = TodosInteractorMock()
		infoDelegate = InfoDelegateMock()
		settingsProvider = TodosSettingsProviderMock()
		itemsFactory = TodoItemsFactoryMock()

		configureTestable()
	}

	override func tearDownWithError() throws {
		sut = nil
		view = nil
		interactor = nil
		infoDelegate = nil
		settingsProvider = nil
		itemsFactory = nil
	}
}

// MARK: - test TodosPresenterProtocol
extension TodosPresenterTests {

	func testPresent() {
		// Arrange

		itemsFactory.stubs.items =
		[
			.header(.random),
			.custom(id: .init(), configuration: .random),
			.custom(id: .init(), configuration: .random),
			.custom(id: .init(), configuration: .random)
		]

		let todos: [Todo] = [.random, .random, .random]

		settingsProvider.stubs.grouping = .priority

		// Act
		sut.present(todos)

		// Assert
		guard case let .display(state) = view.invocations[0] else {
			return XCTFail()
		}

		guard case let .content(items) = state else {
			return XCTFail()
		}

		XCTAssertEqual(items, itemsFactory.stubs.items)

		XCTAssertEqual(view.invocations.count, 1)
		guard case let .infoDidChange(info) = infoDelegate.invocations[0] else {
			return XCTFail()
		}
		XCTAssertEqual(info, itemsFactory.stubs.infoSubtitleForCount)
	}

	func testPresentWhenBehaviourIsArchieve() {
		// Arrange
		let todos: [Todo] = [.completed, .completed, .completed]

		configureTestable(behaviour: .archieve)

		settingsProvider.stubs.grouping = .priority

		// Act
		sut.present(todos)

		// Assert
		guard case let .display(state) = view.invocations[0] else {
			return XCTFail()
		}

		guard case let .content(items) = state else {
			return XCTFail()
		}

		XCTAssertEqual(items, itemsFactory.stubs.items)

		XCTAssertEqual(view.invocations.count, 1)
		guard case let .infoDidChange(info) = infoDelegate.invocations[0] else {
			return XCTFail()
		}
		XCTAssertEqual(info, itemsFactory.stubs.infoSubtitleCompletedTodosForCount)
	}

	func testPresentWhenAllTodosAreCompleted() {
		// Arrange

		let todos: [Todo] = [.completed, .completed, .completed]

		configureTestable(behaviour: .list(.init()))

		// Act
		sut.present(todos)

		// Assert
		guard case let .infoDidChange(info) = infoDelegate.invocations[0] else {
			return XCTFail()
		}
		XCTAssertEqual(info, itemsFactory.stubs.infoSubtitleAllTasksAreCompleted)
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
					title: itemsFactory.stubs.placeholderTitle,
					subtitle: itemsFactory.stubs.placeholderSubtitle,
					image: "ghost"
				)
		)
		XCTAssertEqual(view.invocations.count, 1)
		guard case let .infoDidChange(info) = infoDelegate.invocations[0] else {
			return XCTFail()
		}
		XCTAssertEqual(info, itemsFactory.infoSubtitleForEmptyState)
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
		guard case let .insertTodo(id, text) = action else {
			return XCTFail()
		}
		XCTAssertEqual(text, "New todo")

		guard case let .scrollTo(scrollDestination) = view.invocations[0] else {
			return XCTFail()
		}

		XCTAssertEqual(scrollDestination, id)

		guard case let .focusOn(focusDestination) = view.invocations[1] else {
			return XCTFail()
		}

		XCTAssertEqual(focusDestination, id)

		XCTAssertEqual(view.invocations.count, 2)
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

	func testDeleteWhenIdsIsNil() {
		// Arrange
		let expectedIds = [UUID(), UUID()]
		view.selectionStub = expectedIds

		// Act
		sut.delete(nil)

		// Assert
		guard case let .performAction(action) = interactor.invocations[0] else {
			return XCTFail()
		}
		XCTAssertEqual(action, .delete(expectedIds))
	}
}

// MARK: - MenuDelegate
extension TodosPresenterTests {

	func testMenuItemHasBeenClickedWhenItemIsNewTodo() {
		// Act
		sut.menuItemHasBeenClicked(.newTodo)

		// Assert
		guard case let .performAction(action) = interactor.invocations[0] else {
			return XCTFail()
		}
		guard case let .insertTodo(id, text) = action else {
			return XCTFail()
		}
		XCTAssertEqual(text, "New todo")

		guard case let .scrollTo(scrollDestination) = view.invocations[0] else {
			return XCTFail()
		}

		XCTAssertEqual(scrollDestination, id)

		guard case let .focusOn(focusDestination) = view.invocations[1] else {
			return XCTFail()
		}

		XCTAssertEqual(focusDestination, id)

		XCTAssertEqual(view.invocations.count, 2)
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
		XCTAssertEqual(modification, .setStatus(.done))
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
		XCTAssertEqual(modification, .setStatus(.default))
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

		let expectedList = UUID()

		// Act
		sut.menuItemHasBeenClicked(.list(expectedList))

		// Assert
		guard case let .performModification(modification, ids) = interactor.invocations[0] else {
			return XCTFail()
		}
		XCTAssertEqual(ids, expectedIds)
		XCTAssertEqual(modification, .setList(expectedList))
		XCTAssertEqual(interactor.invocations.count, 1)
	}

	func testMenuItemHasBeenClickedWhenItemIsFocusOnTheTask() {
		// Arrange
		let expectedIds = [UUID(), UUID()]
		view.selectionStub = expectedIds

		// Act
		sut.menuItemHasBeenClicked(.focusOn)

		// Assert
		guard case let .performModification(modification, ids) = interactor.invocations[0] else {
			return XCTFail()
		}
		XCTAssertEqual(ids, expectedIds)
		XCTAssertEqual(modification, .setStatus(.inFocus))
		XCTAssertEqual(interactor.invocations.count, 1)
	}

	func testMenuItemHasBeenClickedWhenItemIsLowPriority() {
		// Arrange & Act & Assert
		testMenuItemHasBeenClickedWhenItemIsPriority(itemIdentifier: .priority(.low), expectedValue: .low)
	}

	func testMenuItemHasBeenClickedWhenItemIsMediumPriority() {
		// Arrange & Act & Assert
		testMenuItemHasBeenClickedWhenItemIsPriority(itemIdentifier: .priority(.medium), expectedValue: .medium)
	}

	func testMenuItemHasBeenClickedWhenItemIsHighPriority() {
		// Arrange & Act & Assert
		testMenuItemHasBeenClickedWhenItemIsPriority(itemIdentifier: .priority(.high), expectedValue: .high)
	}
}

// MARK: - Helpers
private extension TodosPresenterTests {

	func testMenuItemHasBeenClickedWhenItemIsPriority(itemIdentifier: MenuItem.Identifier, expectedValue: Priority) {
		// Arrange
		let expectedIds = [UUID(), UUID()]
		view.selectionStub = expectedIds

		// Act
		sut.menuItemHasBeenClicked(itemIdentifier)

		// Assert
		guard case let .performModification(modification, ids) = interactor.invocations[0] else {
			return XCTFail()
		}
		XCTAssertEqual(ids, expectedIds)
		XCTAssertEqual(modification, .setPriority(expectedValue))
		XCTAssertEqual(interactor.invocations.count, 1)
	}
}

// MARK: - Helpers
private extension TodosPresenterTests {

	func configureTestable(behaviour: Behaviour = .inFocus) {
		sut = TodosPresenter(
			infoDelegate: infoDelegate,
			behaviour: behaviour,
			itemsFactory: itemsFactory,
			settingsProvider: settingsProvider
		)
		sut.view = view
		sut.interactor = interactor
	}
}
