//
//  SidebarInteractorTests.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 11.02.2024.
//

import XCTest
@testable import Plan

final class SidebarInteractorTests: XCTestCase {

	private var sut: SidebarInteractor!

	// MARK: - DI

	private var presenter: SidebarPresenterMock!

	private var provider: ListsDataProviderMock!

	private var storage: DataStorageMock!

	override func setUpWithError() throws {
		presenter = SidebarPresenterMock()
		provider = ListsDataProviderMock()
		storage = DataStorageMock()
		sut = SidebarInteractor(
			provider: provider,
			storage: storage
		)
		sut.presenter = presenter
	}

	override func tearDownWithError() throws {
		sut = nil
		presenter = nil
		provider = nil
		storage = nil
	}
}

// MARK: - test SidebarInteractorProtocol
extension SidebarInteractorTests {

	func testFetchLists() {
		// Arrange
		var expectedError: Error?
		provider.errorStub = nil

		// Act
		do {
			try sut.fetchLists()
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

	func testSetTitle() {
		// Arrange
		let expectedText = UUID().uuidString
		let expectedIds = [UUID(), UUID()]
		var expectedError: Error?
		provider.errorStub = nil

		// Act
		do {
			try sut.perform(.setTitle(expectedText), forLists: expectedIds)
		} catch {
			expectedError = error
		}

		// Assert
		XCTAssertNil(expectedError)
		guard case let .performListModification(modification, ids) = storage.invocations[0] else {
			return XCTFail()
		}
		XCTAssertEqual(modification, .setTitle(expectedText))
		XCTAssertEqual(ids, expectedIds)
		guard case .save = storage.invocations[1] else {
			return XCTFail()
		}
		XCTAssertEqual(storage.invocations.count, 2)
	}
}

// MARK: - ListsDataProviderDelegate
extension SidebarInteractorTests {

	func testProviderDidChangeContent() {
		// Arrange
		let lists: [List] = [.random, .random, .random]

		// Act
		sut.providerDidChangeContent(lists)

		// Assert
		guard case let .present(content) = presenter.invocations[0] else {
			return XCTFail()
		}
		XCTAssertEqual(content, lists)
	}
}
