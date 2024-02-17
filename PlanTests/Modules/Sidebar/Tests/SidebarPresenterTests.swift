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

	private var stateProvider: SidebarStateProviderMock!

	private var titleDelegate: TitleDelegateMock!

	override func setUpWithError() throws {
		view = SidebarViewMock()
		interactor = SidebarInteractorMock()
		stateProvider = SidebarStateProviderMock()
		titleDelegate = TitleDelegateMock()
		sut = SidebarPresenter(stateProvider: stateProvider, titleDelegate: titleDelegate)
		sut.view = view
		sut.interactor = interactor
	}

	override func tearDownWithError() throws {
		sut = nil
		view = nil
		interactor = nil
		stateProvider = nil
		titleDelegate = nil
	}
}

// MARK: - test SidebarPresenterProtocol
extension SidebarPresenterTests {

	func testPresent() {
		// Arrange
		let lists: [List] = [.random, .random, .random]

		// Act
		sut.present(lists)

		// Assert
		guard case let .display(staticContent, sectionTitle, dynamicContent) = view.invocations[0] else {
			return XCTFail()
		}

		XCTAssertEqual(staticContent[0], .init(id: .inbox, icon: "tray.fill", title: "In Progress", isEditable: false))
		XCTAssertEqual(staticContent[1], .init(id: .backlog, icon: "square.stack.3d.up.fill", title: "Backlog", isEditable: false))
		XCTAssertEqual(staticContent[2], .init(id: .archieve, icon: "shippingbox.fill", title: "Archieve", isEditable: false))

		XCTAssertEqual(sectionTitle, "Lists")

		XCTAssertEqual(dynamicContent[0], .init(id: .list(lists[0].uuid), icon: "doc.text", title: lists[0].title, isEditable: true))
		XCTAssertEqual(dynamicContent[1], .init(id: .list(lists[1].uuid), icon: "doc.text", title: lists[1].title, isEditable: true))
		XCTAssertEqual(dynamicContent[2], .init(id: .list(lists[2].uuid), icon: "doc.text", title: lists[2].title, isEditable: true))
	}
}

// MARK: - SidebarViewOutput
extension SidebarPresenterTests {

	func testViewDidChange() {
		// Arrange
		stateProvider.routeStub = .backlog

		// Act
		sut.viewDidChange(state: .didLoad)

		// Assert
		guard case .fetchLists = interactor.invocations[0] else {
			return XCTFail()
		}
		guard case let .selectItem(id) = view.invocations[0] else {
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
		stateProvider.routeStub = .backlog

		// Act
		sut.selectionDidChange(expectedItem)

		// Assert
		guard case let .navigate(route) = stateProvider.invocations[0] else {
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
		let result = sut.validateMenuItem(.deleteList)

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
		XCTAssertEqual(action, .insert("New list"))
	}

	func testMenuItemHasBeenClickedWhenMenuItemIsDeleteList() {
		// Arrange
		let expectedId = UUID()
		view.clickedItemStub = .list(expectedId)

		// Act
		sut.menuItemHasBeenClicked(.deleteList)

		// Assert
		guard case let .performAction(action) = interactor.invocations[0] else {
			return XCTFail()
		}
		XCTAssertEqual(action, .delete([expectedId]))
	}
}
