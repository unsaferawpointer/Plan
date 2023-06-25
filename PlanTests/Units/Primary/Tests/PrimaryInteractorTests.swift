//
//  PrimaryInteractorTests.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 24.06.2023.
//

import XCTest
@testable import Plan

final class InteractorPresenterTests: XCTestCase {

	var sut: Primary.Interactor!

	var dataProvider: DataProviderMock!

	var presenter: PrimaryPresenterMock!

	override func setUpWithError() throws {
		dataProvider = DataProviderMock()
		presenter = PrimaryPresenterMock()
		sut = Primary.Interactor(dataProvider: dataProvider)
		sut.presenter = presenter
	}

	override func tearDownWithError() throws {
		sut = nil
		dataProvider = nil
		presenter = nil
	}
}

// MARK: - PrimaryInteractor
extension InteractorPresenterTests {

	func testFetchProjects() throws {
		// Arrange
		let sorting: [ProjectSorting] = [.creationDate(), .name()]
		dataProvider.stubs.fetchProjects = [.init(name: .random), .init(name: .random)]

		// Act
		try sut.fetchProjects(sortBy: sorting)

		// Assert
		guard case let .fetchProjects(sorting) = dataProvider.invocations.first else {
			return XCTFail("`fetchProjects` should be invocked")
		}

		XCTAssertEqual(sorting, [.creationDate(), .name()])

		guard case let .present(projects) = presenter.invocations.first else {
			return XCTFail("`present` should be invocked")
		}

		XCTAssertEqual(projects, dataProvider.stubs.fetchProjects)
	}
}
