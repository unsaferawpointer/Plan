//
//  SidebarPresenterTests.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 11.02.2024.
//

import XCTest
@testable import Plan

final class SidebarPresenterTests: XCTestCase {

	private var sut: SidebarPresenter!

	// MARK: - DI

	private var view: SidebarViewMock!

	private var interactor: SidebarInteractorMock!

	private var settingsProvider: SidebarSettingsProviderMock!

	private var titleDelegate: TitleDelegateMock!

	private var itemsFactory: SidebarItemsFactoryMock!

	override func setUpWithError() throws {
		view = SidebarViewMock()
		interactor = SidebarInteractorMock()
		settingsProvider = SidebarSettingsProviderMock()
		titleDelegate = TitleDelegateMock()
		itemsFactory = SidebarItemsFactoryMock()
		sut = SidebarPresenter(
			settingsProvider: settingsProvider,
			itemsFactory: itemsFactory,
			titleDelegate: titleDelegate
		)
		sut.view = view
		sut.interactor = interactor
	}

	override func tearDownWithError() throws {
		sut = nil
		view = nil
		interactor = nil
		settingsProvider = nil
		itemsFactory = nil
		titleDelegate = nil
	}
}

// MARK: - test SidebarPresenterProtocol
extension SidebarPresenterTests {

	func testPresent() {
		// Arrange
		let lists: [List] = [.random, .random, .random]

		itemsFactory.stubs.dynamicContent = [.random, .random, .random]

		// Act
		sut.present(lists)

		// Assert
		guard case let .displayDynamicContent(sectionTitle, dynamicContent) = view.invocations[0] else {
			return XCTFail()
		}

		XCTAssertEqual(sectionTitle, itemsFactory.stubs.sectionTitle)
		XCTAssertEqual(dynamicContent, itemsFactory.stubs.dynamicContent)
	}

	func testPresentWhenSelectedListHasBeenDeleted() throws {
		// Arrange
		let lists: [List] = [.random, .random, .random]
		itemsFactory.stubs.dynamicContent = [.random, .random, .random]
		itemsFactory.stubs.staticContent = [.random, .random, .random]

		let first = try XCTUnwrap(itemsFactory.stubs.staticContent.first)

		// Select random list
		settingsProvider.stubs.selection = .list(.init())

		// Act
		sut.present(lists)

		// Assert
		guard case let .displayDynamicContent(sectionTitle, dynamicContent) = view.invocations[0] else {
			return XCTFail()
		}

		XCTAssertEqual(sectionTitle, itemsFactory.stubs.sectionTitle)
		XCTAssertEqual(dynamicContent, itemsFactory.stubs.dynamicContent)

		guard case let .selectItem(route) = view.invocations[1] else {
			return XCTFail()
		}

		XCTAssertEqual(route, first.id)

		XCTAssertEqual(view.invocations.count, 2)

		guard case let .titleDidChange(title) = titleDelegate.invocations[0] else {
			return XCTFail()
		}

		XCTAssertEqual(title, first.title)

		guard case let .setSelection(selection) = settingsProvider.invocations[0] else {
			return XCTFail()
		}
		XCTAssertEqual(selection, first.id)
	}
}

// MARK: - SidebarViewOutput
extension SidebarPresenterTests {

	func testViewDidChange() {
		// Arrange
		settingsProvider.stubs.selection = .backlog
		itemsFactory.stubs.staticContent = [.random, .random, .random]

		// Act
		sut.viewDidChange(state: .willAppear)

		// Assert
		guard case .fetchLists = interactor.invocations[0] else {
			return XCTFail()
		}
		guard case let .displayStaticContent(content) = view.invocations[0] else {
			return XCTFail()
		}
		XCTAssertEqual(content, itemsFactory.stubs.staticContent)
		guard case let .selectItem(id) = view.invocations[1] else {
			return XCTFail()
		}
		XCTAssertEqual(id, .backlog)
	}

	func testLabelDidChangeText() {
		// Arrange
		let expectedText = UUID().uuidString
		let expectedId = UUID()

		// Act
		sut.labelDidChangeText(expectedText, forItem: expectedId)

		// Assert
		guard case let .performModification(modification, ids) = interactor.invocations[0] else {
			return XCTFail()
		}
		XCTAssertEqual(modification, .setTitle(expectedText))
		XCTAssertEqual(ids, [expectedId])
	}

	func testSelectionDidChange() {
		// Arrange
		let expectedTitle = UUID().uuidString
		let expectedItem = SidebarItem(id: .backlog, icon: UUID().uuidString, title: expectedTitle, isEditable: false)
		settingsProvider.stubs.selection = .backlog

		// Act
		sut.selectionDidChange(expectedItem)

		// Assert
		guard case let .setSelection(route) = settingsProvider.invocations[0] else {
			return XCTFail()
		}
		XCTAssertEqual(route, .backlog)
	}
}

// MARK: - MenuDelegate test-cases
extension SidebarPresenterTests {

	func testValidateMenuItemWhenMenuItemIsDeleteList() {
		// Arrange
		let expectedId = UUID()
		view.clickedItemStub = .list(expectedId)

		// Act
		let result = sut.validateMenuItem(.delete)

		// Assert
		XCTAssertTrue(result)
	}

	func testValidateMenuItemWhenMenuItemIsNewList() {
		// Act
		let result = sut.validateMenuItem(.newList)

		// Assert
		XCTAssertTrue(result)
	}

	func testMenuItemHasBeenClickedWhenMenuItemIsNewList() {
		// Act
		sut.menuItemHasBeenClicked(.newList)

		// Assert
		guard case let .performAction(action) = interactor.invocations[0] else {
			return XCTFail()
		}
		guard case let .insert(id, title) = action else {
			return XCTFail()
		}
		XCTAssertEqual(title, itemsFactory.stubs.newListTitle)

		guard case let .selectItem(selectedRoute) = view.invocations[0] else {
			return XCTFail()
		}
		XCTAssertEqual(selectedRoute, .list(id))

		guard case let .scrollTo(scrollDestination) = view.invocations[1] else {
			return XCTFail()
		}
		XCTAssertEqual(scrollDestination, .list(id))

		guard case let .focusOn(focusDestination) = view.invocations[2] else {
			return XCTFail()
		}
		XCTAssertEqual(focusDestination, .list(id))

		XCTAssertEqual(view.invocations.count, 3)

		guard case let .titleDidChange(toolbarTitle) = titleDelegate.invocations[0] else {
			return XCTFail()
		}
		XCTAssertEqual(toolbarTitle, title)
	}

	func testMenuItemHasBeenClickedWhenMenuItemIsDeleteList() {
		// Arrange
		let expectedId = UUID()
		view.clickedItemStub = .list(expectedId)

		// Act
		sut.menuItemHasBeenClicked(.delete)

		// Assert
		guard case let .performAction(action) = interactor.invocations[0] else {
			return XCTFail()
		}
		XCTAssertEqual(action, .delete([expectedId]))
	}
}

extension SidebarItem {

	static var random: SidebarItem {
		return .init(
			id: .backlog,
			icon: .random,
			title: .random,
			isEditable: .random()
		)
	}
}
