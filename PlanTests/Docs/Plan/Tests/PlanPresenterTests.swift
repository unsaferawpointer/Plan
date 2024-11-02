//
//  PlanPresenterTests.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 30.08.2024.
//

import XCTest
@testable import Plan

final class PlanPresenterTests: XCTestCase {

	var sut: HierarchyPresenter!

	var statusFactory: PlanStatusFactoryMock!

	var columnsFactory: PlanColumnsFactoryMock!

	var modelFactory: PlanModelFactoryMock!

	var localization: PlanLocalizationMock!

	var formatter: BasicFormatterMock!

	var view: PlanViewMock!

	var interactor: PlanInteractorMock!

	var generalPasteboard: PasteboardFacadeMock!

	override func setUpWithError() throws {

		statusFactory = PlanStatusFactoryMock()

		columnsFactory = PlanColumnsFactoryMock()

		modelFactory = PlanModelFactoryMock()

		localization = PlanLocalizationMock()

		view = PlanViewMock()

		interactor = PlanInteractorMock()

		generalPasteboard = PasteboardFacadeMock()

		sut = HierarchyPresenter(
			provider: AnyStateProvider(initialState: .init()),
			statusFactory: statusFactory,
			modelFactory: modelFactory,
			columnsFactory: columnsFactory,
			localization: localization,
			generalPasteboard: generalPasteboard
		)
		sut.view = view
		sut.interactor = interactor
	}

	override func tearDownWithError() throws {
		sut = nil
		statusFactory = nil
		columnsFactory = nil
		modelFactory = nil
		localization = nil
		view = nil
		generalPasteboard = nil
	}
}

// MARK: - PlanViewOutput interface testing
extension PlanPresenterTests {
	
	func test_viewDidLoad() {
		// Act
		sut.viewDidLoad()

		// Assert
		guard case .setColumnsConfiguration = view.invocations[0] else {
			return XCTFail()
		}

		guard case let .setDropConfiguration(dropConfiguration) = view.invocations[1] else {
			return XCTFail()
		}

		XCTAssertEqual(dropConfiguration.types, [.id, .item, .string])

		guard case .fetchData = interactor.invocations[0] else {
			return XCTFail()
		}

		guard case .expandAll = view.invocations[2] else {
			return XCTFail()
		}
	}

	func test_deleteItems() {
		// Arrange
		view.stubs.selection = [.uuid0, .uuid1, .uuid2]

		// Act
		sut.deleteItems()

		// Assert
		guard case let .deleteItems(ids) = interactor.invocations[0] else {
			return XCTFail()
		}

		XCTAssertEqual(ids, view.stubs.selection)
	}
}
