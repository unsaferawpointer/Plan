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

	private var settingsProvider: TodosSettingsProviderMock!

	override func setUpWithError() throws {
		view = TodosViewMock()
		interactor = TodosInteractorMock()
		stateProvider = TodosStateProviderMock()
		infoDelegate = InfoDelegateMock()
		settingsProvider = TodosSettingsProviderMock()
		sut = TodosPresenter(
			stateProvider: stateProvider,
			infoDelegate: infoDelegate,
			behaviour: .inFocus,
			settingsProvider: settingsProvider
		)
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

		let todo0 = Todo(
			uuid: UUID(),
			creationDate: .now,
			text: UUID().uuidString,
			status: .inFocus,
			priority: .low,
			list: UUID(),
			listName: "list0"
		)

		let todo1 = Todo(
			uuid: UUID(),
			creationDate: .now,
			text: UUID().uuidString,
			status: .done,
			priority: .medium,
			list: UUID(),
			listName: "list1"
		)

		let todo2 = Todo(
			uuid: UUID(),
			creationDate: .now,
			text: UUID().uuidString,
			status: .default,
			priority: .high,
			list: UUID(),
			listName: "list2"
		)

		let todos: [Todo] = [todo0, todo1, todo2]

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

		XCTAssertEqual(items[0], .header("High Priority"))
		XCTAssertEqual(
			items[1],
			.custom(
				id: todo2.uuid,
				configuration: .init(
					checkboxValue: false,
					iconTint: .red,
					iconName: "bolt.fill",
					text: todo2.text,
					textColor: .primaryText,
					trailingText: "list2",
					elements: [.icon, .textfield, .trailingLabel]
				)
			)
		)

		XCTAssertEqual(items[2], .header("Medium Priority"))
		XCTAssertEqual(
			items[3],
			.custom(
				id: todo1.uuid,
				configuration: .init(
					checkboxValue: true,
					iconTint: .secondaryText,
					iconName: "bolt.fill",
					text: todo1.text,
					textColor: .secondaryText,
					trailingText: "list1",
					elements: [.textfield, .trailingLabel]
				)
			)
		)

		XCTAssertEqual(items[4], .header("Low Priority"))
		XCTAssertEqual(
			items[5],
			.custom(
				id: todo0.uuid,
				configuration: .init(
					checkboxValue: false,
					iconTint: .monochrome,
					iconName: "bolt.fill",
					text: todo0.text,
					textColor: .primaryText,
					trailingText: "list0",
					elements: [.textfield, .trailingLabel]
				)
			)
		)

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

// MARK: - MenuDelegate
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
		sut.menuItemHasBeenClicked(.uuid(expectedList))

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
		testMenuItemHasBeenClickedWhenItemIsPriority(itemIdentifier: .lowPriority, expectedValue: .low)
	}

	func testMenuItemHasBeenClickedWhenItemIsMediumPriority() {
		// Arrange & Act & Assert
		testMenuItemHasBeenClickedWhenItemIsPriority(itemIdentifier: .mediumPriority, expectedValue: .medium)
	}

	func testMenuItemHasBeenClickedWhenItemIsHighPriority() {
		// Arrange & Act & Assert
		testMenuItemHasBeenClickedWhenItemIsPriority(itemIdentifier: .highPriority, expectedValue: .high)
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
		XCTAssertEqual(modification, .setUrgency(expectedValue))
		XCTAssertEqual(interactor.invocations.count, 1)
	}
}
