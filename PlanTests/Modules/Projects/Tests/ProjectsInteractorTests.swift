//
//  ProjectsInteractorTests.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 28.01.2024.
//

import XCTest
@testable import Plan

final class ProjectsInteractorTests: XCTestCase {

	private var sut: ProjectsInteractor!

	// MARK: - DI

	private var presenter: ProjectsPresenterMock!

	private var provider: ProjectsDataProviderMock!

	private var storage: PersistentContainerMock!

	override func setUpWithError() throws {
		presenter = ProjectsPresenterMock()
		provider = ProjectsDataProviderMock()
		storage = PersistentContainerMock()
		sut = ProjectsInteractor(
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

// MARK: - test ProjectsInteractorProtocol
extension ProjectsInteractorTests {

	func testFetchProjects() {
		// Arrange
		var expectedError: Error?
		provider.errorStub = nil

		// Act
		do {
			try sut.fetchProjects()
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
		let expectedTitle = UUID().uuidString
		let expectedId = UUID()
		var expectedError: Error?
		provider.errorStub = nil

		// Act
		do {
			try sut.setTitle(expectedTitle, with: expectedId)
		} catch {
			expectedError = error
		}

		// Assert
		XCTAssertNil(expectedError)
		guard case let .setProject(title, id) = storage.invocations[0] else {
			return XCTFail()
		}
		XCTAssertEqual(title, expectedTitle)
		XCTAssertEqual(id, expectedId)
	}
}

// MARK: - ProjectsDataProviderDelegate
extension ProjectsInteractorTests {

	func testProviderDidChangeContent() {
		// Arrange
		let projects: [Project] = [.random, .random, .random]

		// Act
		sut.providerDidChangeContent(projects)

		// Assert
		guard case let .present(content) = presenter.invocations[0] else {
			return XCTFail()
		}
		XCTAssertEqual(content, projects)
	}
}
